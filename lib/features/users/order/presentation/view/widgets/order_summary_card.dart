import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final UserOrderEntity order;
  final String Function(double) formatCurrency;

  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'PAYMENT SUMMARY',
            style: AppStyles.caption.copyWith(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
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
              _buildLineItem('Subtotal', formatCurrency(order.subtotal)),
              const SizedBox(height: 12),
              _buildLineItem(
                'Shipping Fee',
                'FREE',
                valueColor: AppColors.primaryGreen,
                isBoldValue: true,
              ),
              const SizedBox(height: 12),
              _buildLineItem('Tax & Duties', formatCurrency(order.tax)),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1, thickness: 0.5),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: AppStyles.bodyMedium.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'VAT Included',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formatCurrency(order.total),
                      style: AppStyles.headline2.copyWith(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
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

  Widget _buildLineItem(
    String label,
    String value, {
    Color? valueColor,
    bool isBoldValue = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: AppStyles.bodyMedium.copyWith(
            fontSize: 14,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
