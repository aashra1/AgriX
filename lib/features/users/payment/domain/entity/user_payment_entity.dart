import 'package:equatable/equatable.dart';

enum UserPaymentStatus { pending, completed, failed, refunded }

enum UserPaymentMethod { khalti }

class UserPaymentEntity extends Equatable {
  final String? id;
  final String userId;
  final String orderId;
  final double amount;
  final UserPaymentStatus status;
  final UserPaymentMethod paymentMethod;
  final String? transactionId;
  final String? pidx;
  final String? paymentUrl;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserPaymentEntity({
    this.id,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
    this.pidx,
    this.paymentUrl,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  UserPaymentEntity copyWith({
    String? id,
    String? userId,
    String? orderId,
    double? amount,
    UserPaymentStatus? status,
    UserPaymentMethod? paymentMethod,
    String? transactionId,
    String? pidx,
    String? paymentUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPaymentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      pidx: pidx ?? this.pidx,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    orderId,
    amount,
    status,
    paymentMethod,
    transactionId,
    pidx,
    paymentUrl,
    metadata,
    createdAt,
    updatedAt,
  ];
}

class InitiatePaymentEntity extends Equatable {
  final String pidx;
  final String paymentUrl;
  final DateTime expiresAt;
  final String orderId;

  const InitiatePaymentEntity({
    required this.pidx,
    required this.paymentUrl,
    required this.expiresAt,
    required this.orderId,
  });

  @override
  List<Object?> get props => [pidx, paymentUrl, expiresAt, orderId];
}
