import 'package:equatable/equatable.dart';

enum TransactionType { credit, debit }

class BusinessTransactionEntity extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final double balance;
  final String reference;
  final String description;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const BusinessTransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.balance,
    required this.reference,
    required this.description,
    required this.createdAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    balance,
    reference,
    description,
    createdAt,
    metadata,
  ];
}

class BusinessWalletEntity extends Equatable {
  final double balance;
  final String currency;

  const BusinessWalletEntity({required this.balance, required this.currency});

  @override
  List<Object?> get props => [balance, currency];
}
