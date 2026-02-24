import 'package:agrix/features/business/buisness_dashboard/payments/domain/entity/business_transaction_entity.dart';

class BusinessTransactionApiModel {
  final String id;
  final String type;
  final double amount;
  final double balance;
  final String reference;
  final String description;
  final String createdAt;
  final Map<String, dynamic>? metadata;

  BusinessTransactionApiModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balance,
    required this.reference,
    required this.description,
    required this.createdAt,
    this.metadata,
  });

  factory BusinessTransactionApiModel.fromJson(Map<String, dynamic> json) {
    return BusinessTransactionApiModel(
      id: json['_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'credit',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      reference: json['reference']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  BusinessTransactionEntity toEntity() {
    return BusinessTransactionEntity(
      id: id,
      type: type == 'credit' ? TransactionType.credit : TransactionType.debit,
      amount: amount,
      balance: balance,
      reference: reference,
      description: description,
      createdAt: DateTime.parse(createdAt),
      metadata: metadata,
    );
  }

  static List<BusinessTransactionEntity> toEntityList(
    List<BusinessTransactionApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}

class BusinessWalletApiModel {
  final double balance;
  final String currency;

  BusinessWalletApiModel({required this.balance, required this.currency});

  factory BusinessWalletApiModel.fromJson(Map<String, dynamic> json) {
    return BusinessWalletApiModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'NPR',
    );
  }

  BusinessWalletEntity toEntity() {
    return BusinessWalletEntity(balance: balance, currency: currency);
  }
}

class PaginationApiModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationApiModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationApiModel.fromJson(Map<String, dynamic> json) {
    return PaginationApiModel(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      pages: json['pages'] as int? ?? 1,
    );
  }
}
