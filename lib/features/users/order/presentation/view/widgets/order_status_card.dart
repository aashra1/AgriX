import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/order_timeline.dart';
import 'package:flutter/material.dart';

class OrderStatusCard extends StatelessWidget {
  final UserOrderEntity order;
  final String Function(DateTime?) formatDate;

  const OrderStatusCard({
    super.key,
    required this.order,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.orderStatus);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusHeader(
                statusColor: statusColor,
                statusIcon: _getStatusIcon(order.orderStatus),
                statusTitle: _getStatusText(order.orderStatus),
              ),
              _LastUpdateTag(
                date: formatDate(order.updatedAt ?? order.createdAt),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: OrderTimeline(order: order, formatDate: formatDate),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(UserOrderStatus status) {
    return switch (status) {
      UserOrderStatus.delivered => const Color(0xFF10B981),
      UserOrderStatus.shipped => const Color(0xFF3B82F6),
      UserOrderStatus.processing => const Color(0xFF8B5CF6),
      UserOrderStatus.cancelled => const Color(0xFFEF4444),
      UserOrderStatus.pending => const Color(0xFFF59E0B),
    };
  }

  IconData _getStatusIcon(UserOrderStatus status) {
    return switch (status) {
      UserOrderStatus.delivered => Icons.verified_rounded,
      UserOrderStatus.shipped => Icons.local_shipping_rounded,
      UserOrderStatus.processing => Icons.loop_rounded,
      UserOrderStatus.cancelled => Icons.cancel_rounded,
      UserOrderStatus.pending => Icons.access_time_filled_rounded,
    };
  }

  String _getStatusText(UserOrderStatus status) =>
      status.name[0].toUpperCase() + status.name.substring(1).toLowerCase();
}

class _StatusHeader extends StatelessWidget {
  final Color statusColor;
  final IconData statusIcon;
  final String statusTitle;

  const _StatusHeader({
    required this.statusColor,
    required this.statusIcon,
    required this.statusTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CURRENT STATUS',
              style: AppStyles.caption.copyWith(
                color: Colors.grey.shade400,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              statusTitle,
              style: AppStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LastUpdateTag extends StatelessWidget {
  final String date;
  const _LastUpdateTag({required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'LAST UPDATE',
          style: AppStyles.caption.copyWith(
            color: Colors.grey.shade400,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          date,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
