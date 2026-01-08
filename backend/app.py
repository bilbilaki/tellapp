import logging
import os
import sqlite3
import json
import hmac
import hashlib
from urllib.parse import parse_qs
from pathlib import Path
from typing import Optional, Dict, Any
from datetime import datetime

import httpx
from fastapi import FastAPI, HTTPException, Request, Header, status, Depends
from pydantic import BaseModel

# --- Configuration ---
logging.basicConfig(level=logging.INFO)
log = logging.getLogger("miniapp")

app = FastAPI(title="AI Desk Backend", version="0.2.2")

CONFIG_PATH = Path(__file__).parent / "config.json"
DB_PATH = "app.db"
# SECURITY: These must be set in your environment variables
BOT_TOKEN = os.environ.get("BOT_TOKEN") 
ADMIN_SECRET = os.environ.get("ADMIN_SECRET", "change_this_in_production")
TELEGRAM_WEBHOOK_SECRET = os.environ.get("TELEGRAM_WEBHOOK_SECRET") 

# --- Database Management ---
def get_db_connection():
    """Dependency to get DB connection and ensure it closes."""
    # check_same_thread=False is REQUIRED when using sqlite3 with async FastAPI
    conn = sqlite3.connect(DB_PATH, check_same_thread=False)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
    finally:
        conn.close()


def init_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        username TEXT,
        first_name TEXT,
        role TEXT DEFAULT 'guest',
        credits INTEGER DEFAULT 5,
        joined_date TEXT
    )
    ''')
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS payments (
        payment_id TEXT PRIMARY KEY,
        user_id TEXT,
        item TEXT,
        created_at TEXT
    )
    ''')
    conn.commit()
    conn.close()

init_db()

# --- Security: Validation Helper ---
def validate_telegram_data(init_data: str) -> Dict[str, Any]:
    """
    Validates the initData string sent from Telegram WebApp.
    Returns the user object if valid, raises HTTPException if fake.
    """
    if not BOT_TOKEN:
        raise HTTPException(500, "Server misconfigured: BOT_TOKEN missing")
        
    try:
        parsed_data = parse_qs(init_data)
        if 'hash' not in parsed_data:
            raise ValueError("No hash found")
            
        received_hash = parsed_data['hash'][0]
        parsed_data.pop('hash')
        
        # Sort keys alphabetically to recreate the data-check-string
        data_check_string = "\n".join(
            f"{k}={v[0]}" for k, v in sorted(parsed_data.items())
        )
        
        # HMAC Calculation
        secret_key = hmac.new(b"WebAppData", BOT_TOKEN.encode(), hashlib.sha256).digest()
        computed_hash = hmac.new(secret_key, data_check_string.encode(), hashlib.sha256).hexdigest()
        
        if computed_hash != received_hash:
            raise ValueError("Hash mismatch")
            
        # Return the user data as a dict
        user_json = parsed_data.get('user', ['{}'])[0]
        return json.loads(user_json)
        
    except Exception as e:
        log.warning(f"Validation failed: {e}")
        raise HTTPException(status_code=403, detail="Invalid Telegram Authentication")

# --- Pydantic Models ---
class InitRequest(BaseModel):
    initData: str # The raw string from Telegram.WebApp.initData

class ChatRequest(BaseModel):
    message: str
    initData: str # We need this to prove who sent the message
    api_key: Optional[str] = None
    api_base: Optional[str] = None
    model: Optional[str] = None

# --- Helper Functions ---
async def call_model_api(message, config):
    headers = {
        "Authorization": f"Bearer {config['apiKey']}",
        "Content-Type": "application/json",
    }
    body = {
        "model": config['model'],
        "messages": [{"role": "user", "content": message}],
    }
    url = config['apiBase'].rstrip("/") + "/v1/chat/completions"
    
    async with httpx.AsyncClient(timeout=30.0) as client:
        resp = await client.post(url, headers=headers, json=body)
        resp.raise_for_status()
        return resp.json()['choices'][0]['message']['content']

# --- Endpoints ---

@app.post("/api/init")
async def init_user(req: InitRequest, conn: sqlite3.Connection = Depends(get_db_connection)):
    """Register user securely using validated initData"""
    user_data = validate_telegram_data(req.initData)
    user_id = str(user_data['id'])
    
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
    existing = cursor.fetchone()
    
    if existing:
        # Update metadata
        cursor.execute("UPDATE users SET username=?, first_name=? WHERE id=?", 
                       (user_data.get('username'), user_data.get('first_name'), user_id))
        conn.commit()
        return dict(existing) # Return existing user state
    else:
        # Create new
        now = datetime.now().isoformat()
        cursor.execute("INSERT INTO users (id, username, first_name, role, credits, joined_date) VALUES (?, ?, ?, ?, ?, ?)",
                       (user_id, user_data.get('username'), user_data.get('first_name'), 'guest', 5, now))
        conn.commit()
        return {
            "id": user_id, "username": user_data.get('username'), 
            "first_name": user_data.get('first_name'), "role": "guest", "credits": 5
        }

@app.post("/api/chat")
async def chat(req: ChatRequest, conn: sqlite3.Connection = Depends(get_db_connection)):
    # 1. Security Check
    user_data = validate_telegram_data(req.initData)
    user_id = str(user_data['id'])
    
    cursor = conn.cursor()
    
    # 2. Get User Credits
    cursor.execute("SELECT credits, role FROM users WHERE id = ?", (user_id,))
    row = cursor.fetchone()
    
    if not row:
        raise HTTPException(status_code=403, detail="User not initialized")
    
    credits = row['credits']
    role = row['role']
    
    # 3. Check Limits
    if role != 'admin' and credits <= 0:
        return {"reply": "⚠️ You have run out of credits. Please buy more Stars!", "error": "limit_reached"}

    # 4. Config Loading
    server_config = {}
    if CONFIG_PATH.exists():
        server_config = json.loads(CONFIG_PATH.read_text())
    
    final_config = {
        "apiKey": req.api_key or server_config.get("apiKey"),
        "apiBase": req.api_base or server_config.get("apiBase"),
        "model": req.model or server_config.get("model")
    }

    if not final_config['apiKey']:
        return {"reply": "System Error: API Configuration missing."}

    # 5. Call AI
    try:
        reply = await call_model_api(req.message, final_config)
        
        # 6. Deduct Credit Atomically
        if role != 'admin':
            cursor.execute("UPDATE users SET credits = credits - 1 WHERE id = ? AND credits > 0", (user_id,))
            if cursor.rowcount == 0:
                # Race condition caught: ran out of credits during AI call
                return {"reply": "⚠️ limit reached during generation", "error": "limit_reached"}
            conn.commit()
            credits -= 1 # Update local var for display
            
        return {"reply": reply, "credits_left": credits if role != 'admin' else 999}
        
    except Exception as e:
        log.error(f"AI Error: {e}")
        return {"reply": "I'm having trouble connecting right now."}

@app.post("/api/invoice")
async def invoice(item: str, initData: str): # Need initData here too!
    """Generate Invoice Link - Secured"""
    user_data = validate_telegram_data(initData)
    user_id = str(user_data['id'])

    if not BOT_TOKEN:
        raise HTTPException(500, "BOT_TOKEN missing")

    prices = {
        "10_credits": {"amount": 1, "label": "10 Messages"},
        "50_credits": {"amount": 5, "label": "50 Messages"},
    }
    
    if item not in prices:
        raise HTTPException(400, "Invalid item")
        
    selected = prices[item]

    api_url = f"https://api.telegram.org/bot{BOT_TOKEN}/createInvoiceLink"
    payload = {
        "title": "AI Credits",
        "description": f"Top up {selected['label']}",
        "payload": f"{user_id}_{item}", 
        "currency": "XTR",
        "prices": [{"label": selected['label'], "amount": selected['amount']}],
    }

    async with httpx.AsyncClient() as client:
        resp = await client.post(api_url, json=payload)
        return resp.json()

# --- Payment Webhook Handler ---
@app.post("/webhook/telegram")
async def telegram_webhook(
    request: Request, 
    x_telegram_bot_api_secret_token: str = Header(None),
    conn: sqlite3.Connection = Depends(get_db_connection)
):
    """Secure Webhook"""
    # 1. Security: Check Secret Token (Preferred over IP check)
    if not TELEGRAM_WEBHOOK_SECRET or x_telegram_bot_api_secret_token != TELEGRAM_WEBHOOK_SECRET:
        # Fallback to simple logging if secret not set, but block in prod
        log.warning("Potential unauthorized webhook request.")
        if TELEGRAM_WEBHOOK_SECRET:
            raise HTTPException(status.HTTP_403_FORBIDDEN)

    data = await request.json()
    
    # 2. Pre-Checkout
    if 'pre_checkout_query' in data:
        query = data['pre_checkout_query']
        query_id = query['id']
        payload = query['invoice_payload']
        
        # Approve all valid payloads
        is_ok = any(x in payload for x in ["10_credits", "50_credits"])
        
        async with httpx.AsyncClient() as client:
            await client.post(f"https://api.telegram.org/bot{BOT_TOKEN}/answerPreCheckoutQuery", json={
                "pre_checkout_query_id": query_id,
                "ok": is_ok,
                "error_message": "Invalid item" if not is_ok else ""
            })

    # 3. Successful Payment
    if 'message' in data and 'successful_payment' in data['message']:
        payment = data['message']['successful_payment']
        payload = payment['invoice_payload']
        payment_id = payment['telegram_payment_charge_id']
        
        # Idempotency Check
        cursor = conn.cursor()
        cursor.execute("SELECT 1 FROM payments WHERE payment_id = ?", (payment_id,))
        if cursor.fetchone():
            return {"status": "duplicate"}
        
        try:
            user_id, item = payload.split('_', 1)
            credits_map = {"10_credits": 10, "50_credits": 50}
            
            if item in credits_map:
                amount = credits_map[item]
                cursor.execute("UPDATE users SET credits = credits + ? WHERE id = ?", (amount, user_id))
                
                # Log Payment
                cursor.execute("INSERT INTO payments (payment_id, user_id, item, created_at) VALUES (?, ?, ?, ?)",
                               (payment_id, user_id, item, datetime.now().isoformat()))
                conn.commit()
                log.info(f"PAYMENT SUCCESS: User {user_id} bought {item}")
        except Exception as e:
            log.error(f"Payment processing error: {e}")

    return {"status": "ok"}
