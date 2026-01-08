import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_telegram_miniapp/flutter_telegram_miniapp.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'models/payments_models.dart';

// --- Global Config (Matches your CSS Variables) ---
const kBgBody = Color(0xFF131314);
const kBgSurface = Color(0xFF1E1F20);
const kBgSurface2 = Color(0xFF2d2f31);
const kTextPrimary = Color(0xFFE3E3E3);
const kTextSecondary = Color(0xFFC4C7C5);
const kAccentBlue = Color(0xFFA8C7FA);
const kAccentRed = Color(0xFFFF5546);

void main() {
  // 1. Init WebApp() (Your Report: "Initialize the Mini App")
  WebApp().init();
  WebApp().ready();
  WebApp().expand();

  // Set Header Color to match Body
  WebApp().setHeaderColor(kBgBody);
  WebApp().setBackgroundColor(kBgBody);

  runApp(const AiDeskApp());
}

class AiDeskApp extends StatelessWidget {
  const AiDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Desk',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBgBody,
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: kTextPrimary, displayColor: kTextPrimary),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Logic State
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  // User State
  String _firstName = "Guest";
  String _role = "guest";
  int _credits = 10;
  bool _isAdmin = false;
  bool _isWelcomeVisible = true;
  bool _isLoading = false;

  // Backend URL (Change this to your actual backend)
  final String _apiBase = "https://app.inosuke.sbs/api";

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  // --- Logic: Initialization ---
  Future<void> _initUser() async {
    // 1. Fast UI Update (Unsafe Data)
    final user = WebApp().initDataUnsafe.user;
    if (user != null) {
      setState(() {
        _firstName = user.firstName;
        if (user.username?.toLowerCase() == 'p_esil') _isAdmin = true;
      });
    }

    // 2. Secure Login (Safe Data)
    try {
      final res = await http.post(
        Uri.parse('$_apiBase/init'),
        body: jsonEncode({'initData': WebApp().initData}),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _credits = data['credits'];
          _role = data['role'];
          if (_role == 'admin') _isAdmin = true;
        });
      }
    } catch (e) {
      debugPrint("Login Error: $e");
    }
  }

  // --- Logic: Messaging ---
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Credit Check (Client Side)
    if (!_isAdmin && _credits <= 0) {
      WebApp().showAlert(message: "You ran out of credits! Please buy more.");
      _openProfileModal();
      return;
    }

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isWelcomeVisible = false;
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();

    // API Call
    try {
      final res = await http.post(
        Uri.parse('$_apiBase/chat'),
        body: jsonEncode({'message': text, 'initData': WebApp().initData}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(res.body);

      setState(() {
        if (data['error'] == 'limit_reached') {
          _messages.add({"role": "ai", "text": data['reply']});
          _openProfileModal();
        } else {
          _messages.add({"role": "ai", "text": data['reply']});
          if (data['credits_left'] != null) {
            _credits = data['credits_left'];
          }
        }
      });

      // Haptic Feedback (Your Report: "Trigger a physical vibration")
      WebApp().hapticFeedback.impactOccured(
        style: HapticFeedbackImpactStyle.medium,
      );
    } catch (e) {
      _messages.add({"role": "ai", "text": "Error connecting to server."});
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

// --- Logic: Payments ---
  Future<void> _buyItem(String item) async {
    try {
      final res = await http.post(
        Uri.parse('$_apiBase/invoice'),
        body: jsonEncode(
          {'item': item, 'initData': WebApp().initData},
        ), // Fixed: Use WebApp.initData directly if static, or WebApp().initData
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(res.body);
      if (data['result'] != null) {
        // --- FIXED CODE BELOW ---
        WebApp().openInvoice(
          url: data['result'], // 1. Add "url:" label
          callback: (status) {
            // 2. Add "callback:" label
            // Note: 'status' is an enum (InvoiceResult), not a string.
            if (status == InvoiceResult.paid) {
              WebApp().showAlert(message: "Payment Successful! Credits added.");
              setState(() {
                _credits += (item == '10_credits' ? 10 : 50);
              });
            } else if (status == InvoiceResult.cancelled) {
              // Optional: Handle cancellation
            }
          },
        );
        final paymentInfo = SuccessfulPayment.fromJson(data);
        print("Paid amount: ${paymentInfo.totalAmount}");
        // ------------------------
      }
    } catch (e) {
      WebApp().showAlert(message: 'Error creating invoice');
    }
  }
  // --- UI: Modals ---
  void _openProfileModal() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: kBgSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModalHeader("Profile"),
              const SizedBox(height: 16),
              _buildInfoRow("Name", _firstName),
              _buildInfoRow("Credits", "$_credits", color: kAccentBlue),
              _buildInfoRow("Status", _role.toUpperCase()),
              const SizedBox(height: 24),
              _buildModalHeader("Get More Credits"),
              const SizedBox(height: 10),
              _buildBtn(
                "Buy 10 Messages (1 Star) ✨",
                () => _buyItem("10_credits"),
                color: kAccentBlue,
              ),
              const SizedBox(height: 8),
              _buildBtn(
                "Buy 50 Messages (5 Stars) 🌟",
                () => _buyItem("50_credits"),
                color: kAccentBlue,
              ),
              const SizedBox(height: 16),
              if (_isAdmin)
                _buildBtn(
                  "Open Admin Panel",
                  () {
                    Navigator.pop(ctx);
                    // Implement Admin Logic here if needed
                  },
                  isGhost: true,
                  color: kAccentRed,
                ),
              _buildBtn("Close", () => Navigator.pop(ctx), isGhost: true),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---
  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kTextSecondary)),
          Text(
            value,
            style: TextStyle(
              color: color ?? kTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(
    String text,
    VoidCallback onTap, {
    bool isGhost = false,
    Color color = kTextSecondary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isGhost
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color.withOpacity(0.5)),
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(text),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget _buildModalHeader(String text) => Text(
    text,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Top Bar ---
      appBar: AppBar(
        backgroundColor: kBgBody,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.auto_awesome, color: Colors.blue), // Replaces 'sparkle'
            SizedBox(width: 8),
            Text("AI Desk", style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: _openProfileModal,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kAccentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, size: 16, color: kAccentBlue),
                  const SizedBox(width: 4),
                  Text(
                    _isAdmin ? "∞" : "$_credits Left",
                    style: const TextStyle(color: kAccentBlue, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- Body ---
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: Stack(
              children: [
                if (_isWelcomeVisible)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF4285F4), Color(0xFFD96570)],
                            ).createShader(bounds),
                            child: Text(
                              "Hello, $_firstName",
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "How can I help you?",
                            style: TextStyle(
                              fontSize: 28,
                              color: Color(0xFF444746),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['role'] == 'user';
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? kBgSurface2 : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: isUser
                                ? const Radius.circular(20)
                                : const Radius.circular(4),
                            bottomRight: isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          msg['text']!,
                          style: const TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // --- Input Area (Sticky Bottom) ---
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            color: kBgBody,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kBgSurface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_upward,
                      color: _controller.text.trim().isEmpty
                          ? Colors.grey
                          : kTextPrimary,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
