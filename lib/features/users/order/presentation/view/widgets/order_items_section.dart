import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/order_item_card.dart';
import 'package:flutter/material.dart';

class OrderItemsSection extends StatelessWidget {
  final UserOrderEntity order;
  final String Function(double) formatCurrency;
  final String Function(String?) getProductImageUrl;

  const OrderItemsSection({
    super.key,
    required this.order,
    required this.formatCurrency,
    required this.getProductImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Refined Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER BUNDLE',
                    style: AppStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    '${order.items.length} ${order.items.length == 1 ? 'Item' : 'Items'}',
                    style: AppStyles.headline2.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Item Container
        Container(
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
              ...order.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == order.items.length - 1;

                return Column(
                  children: [
                    OrderItemCard(
                      item: item,
                      formatCurrency: formatCurrency,
                      imageUrl: getProductImageUrl(item.image),
                    ),
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade50,
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
