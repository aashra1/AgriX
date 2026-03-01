import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:flutter/material.dart';

class ShippingAddressCard extends StatelessWidget {
  final UserOrderEntity order;

  const ShippingAddressCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'SHIPPING DESTINATION',
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Visual Anchor Column
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_pin_circle_rounded,
                      color: AppColors.primaryGreen,
                      size: 18,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // 2. Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shippingAddress.fullName,
                      style: AppStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.shippingAddress.phone,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, thickness: 0.5),
                    ),
                    Text(
                      '${order.shippingAddress.addressLine1}${order.shippingAddress.addressLine2 != null ? ', ${order.shippingAddress.addressLine2}' : ''}',
                      style: AppStyles.bodyMedium.copyWith(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.shippingAddress.city}, ${order.shippingAddress.state} ${order.shippingAddress.postalCode}',
                      style: AppStyles.caption.copyWith(
                        fontSize: 12,
                        color: Colors.grey.shade400,
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
}
