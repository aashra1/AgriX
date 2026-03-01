import 'dart:ui';

import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:flutter/material.dart';

class OrderDetailAppBar extends StatelessWidget {
  final UserOrderEntity order;
  final String Function(DateTime?) formatDateTime;
  final VoidCallback onBackPressed;

  const OrderDetailAppBar({
    super.key,
    required this.order,
    required this.formatDateTime,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.orderStatus);
    final orderId =
        order.id?.substring(order.id!.length - 8).toUpperCase() ?? "0000";

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0.9),
      surfaceTintColor: Colors.transparent,
      leading: Center(
        child: _CircularIconButton(
          icon: Icons.chevron_left_rounded,
          onPressed: onBackPressed,
        ),
      ),
      actions: [
        _StatusBadge(status: order.orderStatus, color: statusColor),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        title: _CollapsingIdTitle(orderId: orderId),
        background: const _AppBarBackground(),
      ),
    );
  }

  Color _getStatusColor(UserOrderStatus status) {
    return switch (status) {
      UserOrderStatus.delivered => const Color(0xFF2ECC71),
      UserOrderStatus.shipped => const Color(0xFF3498DB),
      UserOrderStatus.processing => const Color(0xFF9B59B6),
      UserOrderStatus.cancelled => const Color(0xFFE74C3C),
      UserOrderStatus.pending => const Color(0xFFF1C40F),
    };
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _CircularIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87, size: 22),
        onPressed: onPressed,
      ),
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: CircleAvatar(
              radius: 110,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.05),
            ),
          ),
          Positioned(
            top: 40,
            right: 60,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.03),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsingIdTitle extends StatelessWidget {
  final String orderId;
  const _CollapsingIdTitle({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, settings) {
        final double collapseProgress = (1.0 -
                (settings.maxHeight - kToolbarHeight) / (200 - kToolbarHeight))
            .clamp(0.0, 1.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: (1.0 - collapseProgress * 2.5).clamp(0.0, 1.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'OFFICIAL INVOICE',
                  style: AppStyles.caption.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 7,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            if (collapseProgress < 0.4)
              Opacity(
                opacity: (1.0 - collapseProgress * 3).clamp(0.0, 1.0),
                child: Text(
                  'Order ID',
                  style: AppStyles.caption.copyWith(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            Text(
              '#$orderId',
              style: AppStyles.headline2.copyWith(
                fontSize: lerpDouble(24, 16, collapseProgress),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final UserOrderStatus status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.2), width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status.name.toUpperCase(),
                  style: AppStyles.caption.copyWith(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
