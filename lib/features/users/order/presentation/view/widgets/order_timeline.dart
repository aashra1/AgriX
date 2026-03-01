import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:flutter/material.dart';

class OrderTimeline extends StatelessWidget {
  final UserOrderEntity order;
  final String Function(DateTime?) formatDate;

  const OrderTimeline({
    super.key,
    required this.order,
    required this.formatDate,
  });

  List<Map<String, dynamic>> _getTimelineSteps() {
    final steps = <Map<String, dynamic>>[];

    // Order Placed - Always completed
    steps.add({
      'title': 'Order Placed',
      'date': order.createdAt,
      'icon': Icons.shopping_bag_outlined,
      'completed': true,
    });

    if (order.orderStatus == UserOrderStatus.cancelled) {
      steps.add({
        'title': 'Cancelled',
        'date': order.updatedAt,
        'icon': Icons.cancel_outlined,
        'completed': true,
        'isError': true,
      });
      return steps;
    }

    // Processing
    final isProcessing =
        order.orderStatus == UserOrderStatus.processing ||
        order.orderStatus == UserOrderStatus.shipped ||
        order.orderStatus == UserOrderStatus.delivered;
    steps.add({
      'title': 'Processing',
      'date': isProcessing ? order.updatedAt : null,
      'icon': Icons.autorenew,
      'completed': isProcessing,
    });

    // Shipped
    final isShipped =
        order.orderStatus == UserOrderStatus.shipped ||
        order.orderStatus == UserOrderStatus.delivered;
    steps.add({
      'title': 'Shipped',
      'date': isShipped ? order.updatedAt : null,
      'icon': Icons.local_shipping_outlined,
      'completed': isShipped,
    });

    // Delivered
    steps.add({
      'title': 'Delivered',
      'date':
          order.orderStatus == UserOrderStatus.delivered
              ? order.updatedAt
              : null,
      'icon': Icons.check_circle_outlined,
      'completed': order.orderStatus == UserOrderStatus.delivered,
    });

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getTimelineSteps();

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        final isError = step['isError'] == true;

        return _TimelineItem(
          step: step,
          isLast: isLast,
          isError: isError,
          formatDate: formatDate,
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Map<String, dynamic> step;
  final bool isLast;
  final bool isError;
  final String Function(DateTime?) formatDate;

  const _TimelineItem({
    required this.step,
    required this.isLast,
    required this.isError,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = step['completed'] as bool;
    final color =
        isError
            ? Colors.red
            : (isCompleted ? AppColors.primaryGreen : Colors.grey.shade300);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? color.withOpacity(0.1)
                          : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step['icon'] as IconData,
                  size: 14,
                  color: isCompleted ? color : Colors.grey.shade400,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 30,
                  color:
                      isCompleted
                          ? color.withOpacity(0.3)
                          : Colors.grey.shade200,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title'],
                    style: AppStyles.bodyText2.copyWith(
                      fontWeight:
                          isCompleted ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isCompleted
                              ? (isError ? Colors.red : Colors.black87)
                              : Colors.grey.shade500,
                    ),
                  ),
                  if (step['date'] != null)
                    Text(
                      formatDate(step['date']),
                      style: AppStyles.caption.copyWith(
                        color:
                            isError
                                ? Colors.red.shade300
                                : Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
