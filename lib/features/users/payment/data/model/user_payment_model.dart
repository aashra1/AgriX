import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';

class UserPaymentApiModel {
  final String? id;
  final String userId;
  final String orderId;
  final double amount;
  final String status;
  final String paymentMethod;
  final String? transactionId;
  final String? pidx;
  final String? paymentUrl;
  final Map<String, dynamic>? metadata;
  final String? createdAt;
  final String? updatedAt;

  UserPaymentApiModel({
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

  factory UserPaymentApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> paymentData;
    if (json.containsKey('payment') && json['payment'] != null) {
      paymentData = json['payment'] as Map<String, dynamic>;
    } else if (json.containsKey('data') && json['data'] != null) {
      paymentData = json['data'] as Map<String, dynamic>;
    } else {
      paymentData = json;
    }

    return UserPaymentApiModel(
      id: paymentData['_id']?.toString(),
      userId: paymentData['userId']?.toString() ?? '',
      orderId: paymentData['orderId']?.toString() ?? '',
      amount: (paymentData['amount'] as num?)?.toDouble() ?? 0.0,
      status: paymentData['status']?.toString() ?? 'pending',
      paymentMethod: paymentData['paymentMethod']?.toString() ?? 'khalti',
      transactionId: paymentData['transactionId']?.toString(),
      pidx: paymentData['pidx']?.toString(),
      paymentUrl: paymentData['paymentUrl']?.toString(),
      metadata: paymentData['metadata'] as Map<String, dynamic>?,
      createdAt: paymentData['createdAt']?.toString(),
      updatedAt: paymentData['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      if (transactionId != null) 'transactionId': transactionId,
      if (pidx != null) 'pidx': pidx,
      if (paymentUrl != null) 'paymentUrl': paymentUrl,
      if (metadata != null) 'metadata': metadata,
    };
  }

  UserPaymentEntity toEntity() {
    return UserPaymentEntity(
      id: id,
      userId: userId,
      orderId: orderId,
      amount: amount,
      status: _parseStatus(status),
      paymentMethod: _parsePaymentMethod(paymentMethod),
      transactionId: transactionId,
      pidx: pidx,
      paymentUrl: paymentUrl,
      metadata: metadata,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  static List<UserPaymentEntity> toEntityList(
    List<UserPaymentApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  UserPaymentStatus _parseStatus(String value) {
    switch (value.toLowerCase()) {
      case 'completed':
        return UserPaymentStatus.completed;
      case 'failed':
        return UserPaymentStatus.failed;
      case 'refunded':
        return UserPaymentStatus.refunded;
      case 'pending':
      default:
        return UserPaymentStatus.pending;
    }
  }

  UserPaymentMethod _parsePaymentMethod(String value) {
    switch (value.toLowerCase()) {
      case 'khalti':
      default:
        return UserPaymentMethod.khalti;
    }
  }
}

class InitiatePaymentApiModel {
  final String pidx;
  final String paymentUrl;
  final int expiresIn;
  final String orderId;

  InitiatePaymentApiModel({
    required this.pidx,
    required this.paymentUrl,
    required this.expiresIn,
    required this.orderId,
  });

  factory InitiatePaymentApiModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return InitiatePaymentApiModel(
      pidx: data['pidx']?.toString() ?? '',
      paymentUrl:
          data['payment_url']?.toString() ??
          data['paymentUrl']?.toString() ??
          '',
      expiresIn: (data['expires_in'] as num?)?.toInt() ?? 300,
      orderId:
          data['orderId']?.toString() ??
          data['purchase_order_id']?.toString() ??
          '',
    );
  }

  InitiatePaymentEntity toEntity() {
    return InitiatePaymentEntity(
      pidx: pidx,
      paymentUrl: paymentUrl,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      orderId: orderId,
    );
  }
}
