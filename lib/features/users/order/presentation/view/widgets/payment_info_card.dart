import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:flutter/material.dart';

class PaymentInfoCard extends StatelessWidget {
  final UserOrderEntity order;
  final String Function(double) formatCurrency;

  const PaymentInfoCard({
    super.key,
    required this.order,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getPaymentStatusColor(order.paymentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'TRANSACTION RECEIPT',
            style: AppStyles.caption.copyWith(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _PaymentIcon(method: order.paymentMethod),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getPaymentMethodText(order.paymentMethod),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatCurrency(order.total),
                              style: AppStyles.headline2.copyWith(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _StatusBadge(
                      label: order.paymentStatus.name,
                      color: statusColor,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_moon_outlined,
                      size: 14,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Secured by 256-bit encryption',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getPaymentStatusColor(UserOrderPaymentStatus status) {
    return switch (status) {
      UserOrderPaymentStatus.completed => const Color(0xFF10B981),
      UserOrderPaymentStatus.failed => const Color(0xFFEF4444),
      UserOrderPaymentStatus.refunded => const Color(0xFF6366F1),
      UserOrderPaymentStatus.pending => const Color(0xFFF59E0B),
    };
  }

  String _getPaymentMethodText(UserOrderPaymentMethod method) {
    return switch (method) {
      UserOrderPaymentMethod.cod => 'Cash on Delivery',
      UserOrderPaymentMethod.khalti => 'Khalti Wallet',
    };
  }
}

class _PaymentIcon extends StatelessWidget {
  final UserOrderPaymentMethod method;
  const _PaymentIcon({required this.method});

  @override
  Widget build(BuildContext context) {
    final bool isCod = method == UserOrderPaymentMethod.cod;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isCod ? Colors.orange.shade50 : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isCod ? Icons.payments_rounded : Icons.account_balance_wallet_rounded,
        color: isCod ? Colors.orange.shade700 : Colors.purple.shade700,
        size: 20,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
