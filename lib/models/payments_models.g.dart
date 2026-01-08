// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  isBot: json['isBot'] as bool,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String?,
  username: json['username'] as String?,
  languageCode: json['languageCode'] as String?,
  isPremium: json['isPremium'] as bool?,
  addedToAttachmentMenu: json['addedToAttachmentMenu'] as bool?,
  canJoinGroups: json['canJoinGroups'] as bool?,
  canReadAllGroupMessages: json['canReadAllGroupMessages'] as bool?,
  supportsInlineQueries: json['supportsInlineQueries'] as bool?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'isBot': instance.isBot,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'username': instance.username,
  'languageCode': instance.languageCode,
  'isPremium': instance.isPremium,
  'addedToAttachmentMenu': instance.addedToAttachmentMenu,
  'canJoinGroups': instance.canJoinGroups,
  'canReadAllGroupMessages': instance.canReadAllGroupMessages,
  'supportsInlineQueries': instance.supportsInlineQueries,
};

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  title: json['title'] as String?,
  username: json['username'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'username': instance.username,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
};

PaidMedia _$PaidMediaFromJson(Map<String, dynamic> json) =>
    PaidMedia(type: json['type'] as String);

Map<String, dynamic> _$PaidMediaToJson(PaidMedia instance) => <String, dynamic>{
  'type': instance.type,
};

Gift _$GiftFromJson(Map<String, dynamic> json) =>
    Gift(id: json['id'] as String);

Map<String, dynamic> _$GiftToJson(Gift instance) => <String, dynamic>{
  'id': instance.id,
};

LabeledPrice _$LabeledPriceFromJson(Map<String, dynamic> json) => LabeledPrice(
  label: json['label'] as String,
  amount: (json['amount'] as num).toInt(),
);

Map<String, dynamic> _$LabeledPriceToJson(LabeledPrice instance) =>
    <String, dynamic>{'label': instance.label, 'amount': instance.amount};

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
  title: json['title'] as String,
  description: json['description'] as String,
  startParameter: json['startParameter'] as String,
  currency: json['currency'] as String,
  totalAmount: (json['totalAmount'] as num).toInt(),
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'startParameter': instance.startParameter,
  'currency': instance.currency,
  'totalAmount': instance.totalAmount,
};

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      countryCode: json['countryCode'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      streetLine1: json['streetLine1'] as String,
      streetLine2: json['streetLine2'] as String,
      postCode: json['postCode'] as String,
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'state': instance.state,
      'city': instance.city,
      'streetLine1': instance.streetLine1,
      'streetLine2': instance.streetLine2,
      'postCode': instance.postCode,
    };

OrderInfo _$OrderInfoFromJson(Map<String, dynamic> json) => OrderInfo(
  name: json['name'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  shippingAddress: json['shippingAddress'] == null
      ? null
      : ShippingAddress.fromJson(
          json['shippingAddress'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OrderInfoToJson(OrderInfo instance) => <String, dynamic>{
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'shippingAddress': instance.shippingAddress,
};

ShippingOption _$ShippingOptionFromJson(Map<String, dynamic> json) =>
    ShippingOption(
      id: json['id'] as String,
      title: json['title'] as String,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => LabeledPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShippingOptionToJson(ShippingOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'prices': instance.prices,
    };

SuccessfulPayment _$SuccessfulPaymentFromJson(Map<String, dynamic> json) =>
    SuccessfulPayment(
      currency: json['currency'] as String,
      totalAmount: (json['totalAmount'] as num).toInt(),
      invoicePayload: json['invoicePayload'] as String,
      subscriptionExpirationDate: (json['subscriptionExpirationDate'] as num?)
          ?.toInt(),
      isRecurring: json['isRecurring'] as bool?,
      isFirstRecurring: json['isFirstRecurring'] as bool?,
      shippingOptionId: json['shippingOptionId'] as String?,
      orderInfo: json['orderInfo'] == null
          ? null
          : OrderInfo.fromJson(json['orderInfo'] as Map<String, dynamic>),
      telegramPaymentChargeId: json['telegramPaymentChargeId'] as String,
      providerPaymentChargeId: json['providerPaymentChargeId'] as String,
    );

Map<String, dynamic> _$SuccessfulPaymentToJson(SuccessfulPayment instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'totalAmount': instance.totalAmount,
      'invoicePayload': instance.invoicePayload,
      'subscriptionExpirationDate': instance.subscriptionExpirationDate,
      'isRecurring': instance.isRecurring,
      'isFirstRecurring': instance.isFirstRecurring,
      'shippingOptionId': instance.shippingOptionId,
      'orderInfo': instance.orderInfo,
      'telegramPaymentChargeId': instance.telegramPaymentChargeId,
      'providerPaymentChargeId': instance.providerPaymentChargeId,
    };

RefundedPayment _$RefundedPaymentFromJson(Map<String, dynamic> json) =>
    RefundedPayment(
      currency: json['currency'] as String,
      totalAmount: (json['totalAmount'] as num).toInt(),
      invoicePayload: json['invoicePayload'] as String,
      telegramPaymentChargeId: json['telegramPaymentChargeId'] as String,
      providerPaymentChargeId: json['providerPaymentChargeId'] as String?,
    );

Map<String, dynamic> _$RefundedPaymentToJson(RefundedPayment instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'totalAmount': instance.totalAmount,
      'invoicePayload': instance.invoicePayload,
      'telegramPaymentChargeId': instance.telegramPaymentChargeId,
      'providerPaymentChargeId': instance.providerPaymentChargeId,
    };

ShippingQuery _$ShippingQueryFromJson(Map<String, dynamic> json) =>
    ShippingQuery(
      id: json['id'] as String,
      from: User.fromJson(json['from'] as Map<String, dynamic>),
      invoicePayload: json['invoicePayload'] as String,
      shippingAddress: ShippingAddress.fromJson(
        json['shippingAddress'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ShippingQueryToJson(ShippingQuery instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'invoicePayload': instance.invoicePayload,
      'shippingAddress': instance.shippingAddress,
    };

PreCheckoutQuery _$PreCheckoutQueryFromJson(Map<String, dynamic> json) =>
    PreCheckoutQuery(
      id: json['id'] as String,
      from: User.fromJson(json['from'] as Map<String, dynamic>),
      currency: json['currency'] as String,
      totalAmount: (json['totalAmount'] as num).toInt(),
      invoicePayload: json['invoicePayload'] as String,
      shippingOptionId: json['shippingOptionId'] as String?,
      orderInfo: json['orderInfo'] == null
          ? null
          : OrderInfo.fromJson(json['orderInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreCheckoutQueryToJson(PreCheckoutQuery instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'currency': instance.currency,
      'totalAmount': instance.totalAmount,
      'invoicePayload': instance.invoicePayload,
      'shippingOptionId': instance.shippingOptionId,
      'orderInfo': instance.orderInfo,
    };

PaidMediaPurchased _$PaidMediaPurchasedFromJson(Map<String, dynamic> json) =>
    PaidMediaPurchased(
      from: User.fromJson(json['from'] as Map<String, dynamic>),
      paidMediaPayload: json['paidMediaPayload'] as String,
    );

Map<String, dynamic> _$PaidMediaPurchasedToJson(PaidMediaPurchased instance) =>
    <String, dynamic>{
      'from': instance.from,
      'paidMediaPayload': instance.paidMediaPayload,
    };

RevenueWithdrawalState _$RevenueWithdrawalStateFromJson(
  Map<String, dynamic> json,
) => RevenueWithdrawalState(type: json['type'] as String);

Map<String, dynamic> _$RevenueWithdrawalStateToJson(
  RevenueWithdrawalState instance,
) => <String, dynamic>{'type': instance.type};

RevenueWithdrawalStatePending _$RevenueWithdrawalStatePendingFromJson(
  Map<String, dynamic> json,
) => RevenueWithdrawalStatePending();

Map<String, dynamic> _$RevenueWithdrawalStatePendingToJson(
  RevenueWithdrawalStatePending instance,
) => <String, dynamic>{};

RevenueWithdrawalStateSucceeded _$RevenueWithdrawalStateSucceededFromJson(
  Map<String, dynamic> json,
) => RevenueWithdrawalStateSucceeded(
  date: (json['date'] as num).toInt(),
  url: json['url'] as String,
);

Map<String, dynamic> _$RevenueWithdrawalStateSucceededToJson(
  RevenueWithdrawalStateSucceeded instance,
) => <String, dynamic>{'date': instance.date, 'url': instance.url};

RevenueWithdrawalStateFailed _$RevenueWithdrawalStateFailedFromJson(
  Map<String, dynamic> json,
) => RevenueWithdrawalStateFailed();

Map<String, dynamic> _$RevenueWithdrawalStateFailedToJson(
  RevenueWithdrawalStateFailed instance,
) => <String, dynamic>{};

AffiliateInfo _$AffiliateInfoFromJson(Map<String, dynamic> json) =>
    AffiliateInfo(
      affiliateUser: json['affiliateUser'] == null
          ? null
          : User.fromJson(json['affiliateUser'] as Map<String, dynamic>),
      affiliateChat: json['affiliateChat'] == null
          ? null
          : Chat.fromJson(json['affiliateChat'] as Map<String, dynamic>),
      commissionPerMille: (json['commissionPerMille'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      nanostarAmount: (json['nanostarAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AffiliateInfoToJson(AffiliateInfo instance) =>
    <String, dynamic>{
      'affiliateUser': instance.affiliateUser,
      'affiliateChat': instance.affiliateChat,
      'commissionPerMille': instance.commissionPerMille,
      'amount': instance.amount,
      'nanostarAmount': instance.nanostarAmount,
    };

TransactionPartner _$TransactionPartnerFromJson(Map<String, dynamic> json) =>
    TransactionPartner(type: json['type'] as String);

Map<String, dynamic> _$TransactionPartnerToJson(TransactionPartner instance) =>
    <String, dynamic>{'type': instance.type};

TransactionPartnerUser _$TransactionPartnerUserFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerUser(
  transactionType: json['transactionType'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  affiliate: json['affiliate'] == null
      ? null
      : AffiliateInfo.fromJson(json['affiliate'] as Map<String, dynamic>),
  invoicePayload: json['invoicePayload'] as String?,
  subscriptionPeriod: (json['subscriptionPeriod'] as num?)?.toInt(),
  paidMedia: (json['paidMedia'] as List<dynamic>?)
      ?.map((e) => PaidMedia.fromJson(e as Map<String, dynamic>))
      .toList(),
  paidMediaPayload: json['paidMediaPayload'] as String?,
  gift: json['gift'] == null
      ? null
      : Gift.fromJson(json['gift'] as Map<String, dynamic>),
  premiumSubscriptionDuration: (json['premiumSubscriptionDuration'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$TransactionPartnerUserToJson(
  TransactionPartnerUser instance,
) => <String, dynamic>{
  'transactionType': instance.transactionType,
  'user': instance.user,
  'affiliate': instance.affiliate,
  'invoicePayload': instance.invoicePayload,
  'subscriptionPeriod': instance.subscriptionPeriod,
  'paidMedia': instance.paidMedia,
  'paidMediaPayload': instance.paidMediaPayload,
  'gift': instance.gift,
  'premiumSubscriptionDuration': instance.premiumSubscriptionDuration,
};

TransactionPartnerChat _$TransactionPartnerChatFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerChat(
  chat: Chat.fromJson(json['chat'] as Map<String, dynamic>),
  gift: json['gift'] == null
      ? null
      : Gift.fromJson(json['gift'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionPartnerChatToJson(
  TransactionPartnerChat instance,
) => <String, dynamic>{'chat': instance.chat, 'gift': instance.gift};

TransactionPartnerAffiliateProgram _$TransactionPartnerAffiliateProgramFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerAffiliateProgram(
  sponsorUser: json['sponsorUser'] == null
      ? null
      : User.fromJson(json['sponsorUser'] as Map<String, dynamic>),
  commissionPerMille: (json['commissionPerMille'] as num).toInt(),
);

Map<String, dynamic> _$TransactionPartnerAffiliateProgramToJson(
  TransactionPartnerAffiliateProgram instance,
) => <String, dynamic>{
  'sponsorUser': instance.sponsorUser,
  'commissionPerMille': instance.commissionPerMille,
};

TransactionPartnerFragment _$TransactionPartnerFragmentFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerFragment(
  withdrawalState:
      _$JsonConverterFromJson<Map<String, dynamic>, RevenueWithdrawalState>(
        json['withdrawalState'],
        const RevenueWithdrawalStateConverter().fromJson,
      ),
);

Map<String, dynamic> _$TransactionPartnerFragmentToJson(
  TransactionPartnerFragment instance,
) => <String, dynamic>{
  'withdrawalState':
      _$JsonConverterToJson<Map<String, dynamic>, RevenueWithdrawalState>(
        instance.withdrawalState,
        const RevenueWithdrawalStateConverter().toJson,
      ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

TransactionPartnerTelegramAds _$TransactionPartnerTelegramAdsFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerTelegramAds();

Map<String, dynamic> _$TransactionPartnerTelegramAdsToJson(
  TransactionPartnerTelegramAds instance,
) => <String, dynamic>{};

TransactionPartnerTelegramApi _$TransactionPartnerTelegramApiFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerTelegramApi(
  requestCount: (json['requestCount'] as num).toInt(),
);

Map<String, dynamic> _$TransactionPartnerTelegramApiToJson(
  TransactionPartnerTelegramApi instance,
) => <String, dynamic>{'requestCount': instance.requestCount};

TransactionPartnerOther _$TransactionPartnerOtherFromJson(
  Map<String, dynamic> json,
) => TransactionPartnerOther();

Map<String, dynamic> _$TransactionPartnerOtherToJson(
  TransactionPartnerOther instance,
) => <String, dynamic>{};

StarTransaction _$StarTransactionFromJson(Map<String, dynamic> json) =>
    StarTransaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      nanostarAmount: (json['nanostarAmount'] as num?)?.toInt(),
      date: (json['date'] as num).toInt(),
      source: const TransactionPartnerConverter().fromJson(
        json['source'] as Map<String, dynamic>?,
      ),
      receiver: const TransactionPartnerConverter().fromJson(
        json['receiver'] as Map<String, dynamic>?,
      ),
    );

Map<String, dynamic> _$StarTransactionToJson(StarTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'nanostarAmount': instance.nanostarAmount,
      'date': instance.date,
      'source': const TransactionPartnerConverter().toJson(instance.source),
      'receiver': const TransactionPartnerConverter().toJson(instance.receiver),
    };

StarTransactions _$StarTransactionsFromJson(Map<String, dynamic> json) =>
    StarTransactions(
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => StarTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StarTransactionsToJson(StarTransactions instance) =>
    <String, dynamic>{'transactions': instance.transactions};

PassportData _$PassportDataFromJson(Map<String, dynamic> json) => PassportData(
  data: (json['data'] as List<dynamic>)
      .map((e) => EncryptedPassportElement.fromJson(e as Map<String, dynamic>))
      .toList(),
  credentials: EncryptedCredentials.fromJson(
    json['credentials'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PassportDataToJson(PassportData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'credentials': instance.credentials,
    };

PassportFile _$PassportFileFromJson(Map<String, dynamic> json) => PassportFile(
  fileId: json['fileId'] as String,
  fileUniqueId: json['fileUniqueId'] as String,
  fileSize: (json['fileSize'] as num).toInt(),
  fileDate: (json['fileDate'] as num).toInt(),
);

Map<String, dynamic> _$PassportFileToJson(PassportFile instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'fileUniqueId': instance.fileUniqueId,
      'fileSize': instance.fileSize,
      'fileDate': instance.fileDate,
    };

EncryptedPassportElement _$EncryptedPassportElementFromJson(
  Map<String, dynamic> json,
) => EncryptedPassportElement(
  type: json['type'] as String,
  data: json['data'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  files: (json['files'] as List<dynamic>?)
      ?.map((e) => PassportFile.fromJson(e as Map<String, dynamic>))
      .toList(),
  frontSide: json['frontSide'] == null
      ? null
      : PassportFile.fromJson(json['frontSide'] as Map<String, dynamic>),
  reverseSide: json['reverseSide'] == null
      ? null
      : PassportFile.fromJson(json['reverseSide'] as Map<String, dynamic>),
  selfie: json['selfie'] == null
      ? null
      : PassportFile.fromJson(json['selfie'] as Map<String, dynamic>),
  translation: (json['translation'] as List<dynamic>?)
      ?.map((e) => PassportFile.fromJson(e as Map<String, dynamic>))
      .toList(),
  hash: json['hash'] as String,
);

Map<String, dynamic> _$EncryptedPassportElementToJson(
  EncryptedPassportElement instance,
) => <String, dynamic>{
  'type': instance.type,
  'data': instance.data,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'files': instance.files,
  'frontSide': instance.frontSide,
  'reverseSide': instance.reverseSide,
  'selfie': instance.selfie,
  'translation': instance.translation,
  'hash': instance.hash,
};

EncryptedCredentials _$EncryptedCredentialsFromJson(
  Map<String, dynamic> json,
) => EncryptedCredentials(
  data: json['data'] as String,
  hash: json['hash'] as String,
  secret: json['secret'] as String,
);

Map<String, dynamic> _$EncryptedCredentialsToJson(
  EncryptedCredentials instance,
) => <String, dynamic>{
  'data': instance.data,
  'hash': instance.hash,
  'secret': instance.secret,
};

StarAmount _$StarAmountFromJson(Map<String, dynamic> json) =>
    StarAmount(amount: (json['amount'] as num).toInt());

Map<String, dynamic> _$StarAmountToJson(StarAmount instance) =>
    <String, dynamic>{'amount': instance.amount};
