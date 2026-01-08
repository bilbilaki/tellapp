import 'package:json_annotation/json_annotation.dart';

part 'payments_models.g.dart';

// Minimal User class
@JsonSerializable()
class User {
  final int id;
  final bool isBot;
  final String firstName;
  final String? lastName;
  final String? username;
  final String? languageCode;
  final bool? isPremium;
  final bool? addedToAttachmentMenu;
  final bool? canJoinGroups;
  final bool? canReadAllGroupMessages;
  final bool? supportsInlineQueries;

  User({
    required this.id,
    required this.isBot,
    required this.firstName,
    this.lastName,
    this.username,
    this.languageCode,
    this.isPremium,
    this.addedToAttachmentMenu,
    this.canJoinGroups,
    this.canReadAllGroupMessages,
    this.supportsInlineQueries,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Placeholder Chat class
@JsonSerializable()
class Chat {
  final int id;
  final String type;
  final String? title;
  final String? username;
  final String? firstName;
  final String? lastName;

  Chat({
    required this.id,
    required this.type,
    this.title,
    this.username,
    this.firstName,
    this.lastName,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

// Placeholder PaidMedia class
@JsonSerializable()
class PaidMedia {
  final String type;

  PaidMedia({required this.type});

  factory PaidMedia.fromJson(Map<String, dynamic> json) =>
      _$PaidMediaFromJson(json);
  Map<String, dynamic> toJson() => _$PaidMediaToJson(this);
}

// Placeholder Gift class
@JsonSerializable()
class Gift {
  final String id;

  Gift({required this.id});

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);
  Map<String, dynamic> toJson() => _$GiftToJson(this);
}

// Custom JsonConverters

class RevenueWithdrawalStateConverter
    implements JsonConverter<RevenueWithdrawalState, Map<String, dynamic>> {
  const RevenueWithdrawalStateConverter();

  @override
  RevenueWithdrawalState fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'pending':
        return RevenueWithdrawalStatePending();
      case 'succeeded':
        return RevenueWithdrawalStateSucceeded(
          date: json['date'] as int,
          url: json['url'] as String,
        );
      case 'failed':
        return RevenueWithdrawalStateFailed();
      default:
        throw ArgumentError(
          'Unknown RevenueWithdrawalState type: ${json['type']}',
        );
    }
  }

  @override
  Map<String, dynamic> toJson(RevenueWithdrawalState object) => object.toJson();
}

class TransactionPartnerConverter
    implements JsonConverter<TransactionPartner?, Map<String, dynamic>?> {
  const TransactionPartnerConverter();

  @override
  TransactionPartner? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    switch (json['type'] as String) {
      case 'user':
        return TransactionPartnerUser.fromJson(json);
      case 'chat':
        return TransactionPartnerChat.fromJson(json);
      case 'affiliate_program':
        return TransactionPartnerAffiliateProgram.fromJson(json);
      case 'fragment':
        return TransactionPartnerFragment.fromJson(json);
      case 'telegram_ads':
        return TransactionPartnerTelegramAds();
      case 'telegram_api':
        return TransactionPartnerTelegramApi(
          requestCount: json['request_count'] as int,
        );
      case 'other':
        return TransactionPartnerOther();
      default:
        throw ArgumentError('Unknown TransactionPartner type: ${json['type']}');
    }
  }

  @override
  Map<String, dynamic>? toJson(TransactionPartner? object) => object?.toJson();
}

// LabeledPrice
@JsonSerializable()
class LabeledPrice {
  final String label;
  final int amount;

  LabeledPrice({required this.label, required this.amount});

  factory LabeledPrice.fromJson(Map<String, dynamic> json) =>
      _$LabeledPriceFromJson(json);
  Map<String, dynamic> toJson() => _$LabeledPriceToJson(this);
}

// Invoice
@JsonSerializable()
class Invoice {
  final String title;
  final String description;
  final String startParameter;
  final String currency;
  final int totalAmount;

  Invoice({
    required this.title,
    required this.description,
    required this.startParameter,
    required this.currency,
    required this.totalAmount,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}

// ShippingAddress
@JsonSerializable()
class ShippingAddress {
  final String countryCode;
  final String state;
  final String city;
  final String streetLine1;
  final String streetLine2;
  final String postCode;

  ShippingAddress({
    required this.countryCode,
    required this.state,
    required this.city,
    required this.streetLine1,
    required this.streetLine2,
    required this.postCode,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}

// OrderInfo
@JsonSerializable()
class OrderInfo {
  final String? name;
  final String? phoneNumber;
  final String? email;
  final ShippingAddress? shippingAddress;

  OrderInfo({this.name, this.phoneNumber, this.email, this.shippingAddress});

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderInfoToJson(this);
}

// ShippingOption
@JsonSerializable()
class ShippingOption {
  final String id;
  final String title;
  final List<LabeledPrice> prices;

  ShippingOption({required this.id, required this.title, required this.prices});

  factory ShippingOption.fromJson(Map<String, dynamic> json) =>
      _$ShippingOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingOptionToJson(this);
}

// SuccessfulPayment
@JsonSerializable()
class SuccessfulPayment {
  final String currency;
  final int totalAmount;
  final String invoicePayload;
  final int? subscriptionExpirationDate;
  final bool? isRecurring;
  final bool? isFirstRecurring;
  final String? shippingOptionId;
  final OrderInfo? orderInfo;
  final String telegramPaymentChargeId;
  final String providerPaymentChargeId;

  SuccessfulPayment({
    required this.currency,
    required this.totalAmount,
    required this.invoicePayload,
    this.subscriptionExpirationDate,
    this.isRecurring,
    this.isFirstRecurring,
    this.shippingOptionId,
    this.orderInfo,
    required this.telegramPaymentChargeId,
    required this.providerPaymentChargeId,
  });

  factory SuccessfulPayment.fromJson(Map<String, dynamic> json) =>
      _$SuccessfulPaymentFromJson(json);
  Map<String, dynamic> toJson() => _$SuccessfulPaymentToJson(this);
}

// RefundedPayment
@JsonSerializable()
class RefundedPayment {
  final String currency;
  final int totalAmount;
  final String invoicePayload;
  final String telegramPaymentChargeId;
  final String? providerPaymentChargeId;

  RefundedPayment({
    required this.currency,
    required this.totalAmount,
    required this.invoicePayload,
    required this.telegramPaymentChargeId,
    this.providerPaymentChargeId,
  });

  factory RefundedPayment.fromJson(Map<String, dynamic> json) =>
      _$RefundedPaymentFromJson(json);
  Map<String, dynamic> toJson() => _$RefundedPaymentToJson(this);
}

// ShippingQuery
@JsonSerializable()
class ShippingQuery {
  final String id;
  final User from;
  final String invoicePayload;
  final ShippingAddress shippingAddress;

  ShippingQuery({
    required this.id,
    required this.from,
    required this.invoicePayload,
    required this.shippingAddress,
  });

  factory ShippingQuery.fromJson(Map<String, dynamic> json) =>
      _$ShippingQueryFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingQueryToJson(this);
}

// PreCheckoutQuery
@JsonSerializable()
class PreCheckoutQuery {
  final String id;
  final User from;
  final String currency;
  final int totalAmount;
  final String invoicePayload;
  final String? shippingOptionId;
  final OrderInfo? orderInfo;

  PreCheckoutQuery({
    required this.id,
    required this.from,
    required this.currency,
    required this.totalAmount,
    required this.invoicePayload,
    this.shippingOptionId,
    this.orderInfo,
  });

  factory PreCheckoutQuery.fromJson(Map<String, dynamic> json) =>
      _$PreCheckoutQueryFromJson(json);
  Map<String, dynamic> toJson() => _$PreCheckoutQueryToJson(this);
}

// PaidMediaPurchased
@JsonSerializable()
class PaidMediaPurchased {
  final User from;
  final String paidMediaPayload;

  PaidMediaPurchased({required this.from, required this.paidMediaPayload});

  factory PaidMediaPurchased.fromJson(Map<String, dynamic> json) =>
      _$PaidMediaPurchasedFromJson(json);
  Map<String, dynamic> toJson() => _$PaidMediaPurchasedToJson(this);
}

// RevenueWithdrawalState
@JsonSerializable()
class RevenueWithdrawalState {
  final String type;

  RevenueWithdrawalState({required this.type});

  factory RevenueWithdrawalState.fromJson(Map<String, dynamic> json) =>
      _$RevenueWithdrawalStateFromJson(json);
  Map<String, dynamic> toJson() => _$RevenueWithdrawalStateToJson(this);
}

// RevenueWithdrawalStatePending
@JsonSerializable()
class RevenueWithdrawalStatePending extends RevenueWithdrawalState {
  RevenueWithdrawalStatePending() : super(type: 'pending');

  factory RevenueWithdrawalStatePending.fromJson(Map<String, dynamic> json) =>
      _$RevenueWithdrawalStatePendingFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RevenueWithdrawalStatePendingToJson(this);
}

// RevenueWithdrawalStateSucceeded
@JsonSerializable()
class RevenueWithdrawalStateSucceeded extends RevenueWithdrawalState {
  final int date;
  final String url;

  RevenueWithdrawalStateSucceeded({required this.date, required this.url})
    : super(type: 'succeeded');

  factory RevenueWithdrawalStateSucceeded.fromJson(Map<String, dynamic> json) =>
      _$RevenueWithdrawalStateSucceededFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      _$RevenueWithdrawalStateSucceededToJson(this);
}

// RevenueWithdrawalStateFailed
@JsonSerializable()
class RevenueWithdrawalStateFailed extends RevenueWithdrawalState {
  RevenueWithdrawalStateFailed() : super(type: 'failed');

  factory RevenueWithdrawalStateFailed.fromJson(Map<String, dynamic> json) =>
      _$RevenueWithdrawalStateFailedFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RevenueWithdrawalStateFailedToJson(this);
}

// AffiliateInfo
@JsonSerializable()
class AffiliateInfo {
  final User? affiliateUser;
  final Chat? affiliateChat;
  final int commissionPerMille;
  final int amount;
  final int? nanostarAmount;

  AffiliateInfo({
    this.affiliateUser,
    this.affiliateChat,
    required this.commissionPerMille,
    required this.amount,
    this.nanostarAmount,
  });

  factory AffiliateInfo.fromJson(Map<String, dynamic> json) =>
      _$AffiliateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AffiliateInfoToJson(this);
}

// TransactionPartner
@JsonSerializable()
class TransactionPartner {
  final String type;

  TransactionPartner({required this.type});

  factory TransactionPartner.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionPartnerToJson(this);
}

// TransactionPartnerUser
@JsonSerializable()
class TransactionPartnerUser extends TransactionPartner {
  final String transactionType;
  final User user;
  final AffiliateInfo? affiliate;
  final String? invoicePayload;
  final int? subscriptionPeriod;
  final List<PaidMedia>? paidMedia;
  final String? paidMediaPayload;
  final Gift? gift;
  final int? premiumSubscriptionDuration;

  TransactionPartnerUser({
    required this.transactionType,
    required this.user,
    this.affiliate,
    this.invoicePayload,
    this.subscriptionPeriod,
    this.paidMedia,
    this.paidMediaPayload,
    this.gift,
    this.premiumSubscriptionDuration,
  }) : super(type: 'user');

  factory TransactionPartnerUser.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerUserFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionPartnerUserToJson(this);
}

// TransactionPartnerChat
@JsonSerializable()
class TransactionPartnerChat extends TransactionPartner {
  final Chat chat;
  final Gift? gift;

  TransactionPartnerChat({required this.chat, this.gift}) : super(type: 'chat');

  factory TransactionPartnerChat.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerChatFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionPartnerChatToJson(this);
}

// TransactionPartnerAffiliateProgram
@JsonSerializable()
class TransactionPartnerAffiliateProgram extends TransactionPartner {
  final User? sponsorUser;
  final int commissionPerMille;

  TransactionPartnerAffiliateProgram({
    this.sponsorUser,
    required this.commissionPerMille,
  }) : super(type: 'affiliate_program');

  factory TransactionPartnerAffiliateProgram.fromJson(
    Map<String, dynamic> json,
  ) => _$TransactionPartnerAffiliateProgramFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      _$TransactionPartnerAffiliateProgramToJson(this);
}

// TransactionPartnerFragment
@JsonSerializable()
class TransactionPartnerFragment extends TransactionPartner {
  @RevenueWithdrawalStateConverter()
  final RevenueWithdrawalState? withdrawalState;

  TransactionPartnerFragment({this.withdrawalState}) : super(type: 'fragment');

  factory TransactionPartnerFragment.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerFragmentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionPartnerFragmentToJson(this);
}

// TransactionPartnerTelegramAds
@JsonSerializable()
class TransactionPartnerTelegramAds extends TransactionPartner {
  TransactionPartnerTelegramAds() : super(type: 'telegram_ads');

  factory TransactionPartnerTelegramAds.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerTelegramAdsFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionPartnerTelegramAdsToJson(this);
}

// TransactionPartnerTelegramApi
@JsonSerializable()
class TransactionPartnerTelegramApi extends TransactionPartner {
  final int requestCount;

  TransactionPartnerTelegramApi({required this.requestCount})
    : super(type: 'telegram_api');

  factory TransactionPartnerTelegramApi.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerTelegramApiFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionPartnerTelegramApiToJson(this);
}

// TransactionPartnerOther
@JsonSerializable()
class TransactionPartnerOther extends TransactionPartner {
  TransactionPartnerOther() : super(type: 'other');

  factory TransactionPartnerOther.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartnerOtherFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionPartnerOtherToJson(this);
}

// StarTransaction
@JsonSerializable()
class StarTransaction {
  final String id;
  final int amount;
  final int? nanostarAmount;
  final int date;
  @TransactionPartnerConverter()
  final TransactionPartner? source;
  @TransactionPartnerConverter()
  final TransactionPartner? receiver;

  StarTransaction({
    required this.id,
    required this.amount,
    this.nanostarAmount,
    required this.date,
    this.source,
    this.receiver,
  });

  factory StarTransaction.fromJson(Map<String, dynamic> json) =>
      _$StarTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$StarTransactionToJson(this);
}

// StarTransactions
@JsonSerializable()
class StarTransactions {
  final List<StarTransaction> transactions;

  StarTransactions({required this.transactions});

  factory StarTransactions.fromJson(Map<String, dynamic> json) =>
      _$StarTransactionsFromJson(json);
  Map<String, dynamic> toJson() => _$StarTransactionsToJson(this);
}

// PassportData
@JsonSerializable()
class PassportData {
  final List<EncryptedPassportElement> data;
  final EncryptedCredentials credentials;

  PassportData({required this.data, required this.credentials});

  factory PassportData.fromJson(Map<String, dynamic> json) =>
      _$PassportDataFromJson(json);
  Map<String, dynamic> toJson() => _$PassportDataToJson(this);
}

// PassportFile
@JsonSerializable()
class PassportFile {
  final String fileId;
  final String fileUniqueId;
  final int fileSize;
  final int fileDate;

  PassportFile({
    required this.fileId,
    required this.fileUniqueId,
    required this.fileSize,
    required this.fileDate,
  });

  factory PassportFile.fromJson(Map<String, dynamic> json) =>
      _$PassportFileFromJson(json);
  Map<String, dynamic> toJson() => _$PassportFileToJson(this);
}

// EncryptedPassportElement
@JsonSerializable()
class EncryptedPassportElement {
  final String type;
  final String? data;
  final String? phoneNumber;
  final String? email;
  final List<PassportFile>? files;
  final PassportFile? frontSide;
  final PassportFile? reverseSide;
  final PassportFile? selfie;
  final List<PassportFile>? translation;
  final String hash;

  EncryptedPassportElement({
    required this.type,
    this.data,
    this.phoneNumber,
    this.email,
    this.files,
    this.frontSide,
    this.reverseSide,
    this.selfie,
    this.translation,
    required this.hash,
  });

  factory EncryptedPassportElement.fromJson(Map<String, dynamic> json) =>
      _$EncryptedPassportElementFromJson(json);
  Map<String, dynamic> toJson() => _$EncryptedPassportElementToJson(this);
}

// EncryptedCredentials
@JsonSerializable()
class EncryptedCredentials {
  final String data;
  final String hash;
  final String secret;

  EncryptedCredentials({
    required this.data,
    required this.hash,
    required this.secret,
  });

  factory EncryptedCredentials.fromJson(Map<String, dynamic> json) =>
      _$EncryptedCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$EncryptedCredentialsToJson(this);
}

// StarAmount
@JsonSerializable()
class StarAmount {
  final int amount;

  StarAmount({required this.amount});

  factory StarAmount.fromJson(Map<String, dynamic> json) =>
      _$StarAmountFromJson(json);
  Map<String, dynamic> toJson() => _$StarAmountToJson(this);
}
