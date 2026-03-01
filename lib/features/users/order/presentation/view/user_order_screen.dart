import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/home/home_screen.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/presentation/state/user_order_state.dart';
import 'package:agrix/features/users/order/presentation/view/user_order_detail_screen.dart';
import 'package:agrix/features/users/order/presentation/viewmodel/user_order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserOrdersScreen extends ConsumerStatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  ConsumerState<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends ConsumerState<UserOrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  UserOrderStatus? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOrders());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders({bool refresh = false}) async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }
    await ref
        .read(userOrderViewModelProvider.notifier)
        .getUserOrders(token: token, refresh: refresh);
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacementNamed(context, '/login'),
    );
  }

  String _formatCurrency(double amount) =>
      NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0).format(amount);

  String _formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    return _formatDate(date);
  }

  String _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/product-images/$fileName';
  }

  Color _getStatusColor(UserOrderStatus status) {
    switch (status) {
      case UserOrderStatus.delivered:
        return const Color(0xFF10B981);
      case UserOrderStatus.shipped:
        return const Color(0xFF3B82F6);
      case UserOrderStatus.processing:
        return const Color(0xFF8B5CF6);
      case UserOrderStatus.cancelled:
        return const Color(0xFFEF4444);
      case UserOrderStatus.pending:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getStatusIcon(UserOrderStatus status) {
    switch (status) {
      case UserOrderStatus.delivered:
        return Icons.check_circle;
      case UserOrderStatus.shipped:
        return Icons.local_shipping;
      case UserOrderStatus.processing:
        return Icons.pending_actions;
      case UserOrderStatus.cancelled:
        return Icons.cancel;
      case UserOrderStatus.pending:
        return Icons.access_time;
    }
  }

  String _getStatusText(UserOrderStatus status) {
    switch (status) {
      case UserOrderStatus.delivered:
        return 'Delivered';
      case UserOrderStatus.shipped:
        return 'Shipped';
      case UserOrderStatus.processing:
        return 'Processing';
      case UserOrderStatus.cancelled:
        return 'Cancelled';
      case UserOrderStatus.pending:
        return 'Pending';
    }
  }

  String _getPaymentMethodText(UserOrderPaymentMethod? method) {
    if (method == null) return 'COD';
    switch (method) {
      case UserOrderPaymentMethod.cod:
        return 'COD';
      case UserOrderPaymentMethod.khalti:
        return 'KHALTI';
    }
  }

  Color _getPaymentStatusColor(UserOrderPaymentStatus? status) {
    if (status == null) return Colors.orange;
    switch (status) {
      case UserOrderPaymentStatus.completed:
        return Colors.green;
      case UserOrderPaymentStatus.failed:
        return Colors.red;
      case UserOrderPaymentStatus.refunded:
        return Colors.purple;
      case UserOrderPaymentStatus.pending:
        return Colors.orange;
    }
  }

  IconData _getPaymentStatusIcon(UserOrderPaymentStatus? status) {
    if (status == null) return Icons.access_time;
    switch (status) {
      case UserOrderPaymentStatus.completed:
        return Icons.payment;
      case UserOrderPaymentStatus.failed:
        return Icons.error_outline;
      case UserOrderPaymentStatus.refunded:
        return Icons.assignment_return;
      case UserOrderPaymentStatus.pending:
        return Icons.access_time;
    }
  }

  String _getPaymentStatusText(UserOrderPaymentStatus? status) {
    if (status == null) return 'Pending';
    switch (status) {
      case UserOrderPaymentStatus.completed:
        return 'Completed';
      case UserOrderPaymentStatus.failed:
        return 'Failed';
      case UserOrderPaymentStatus.refunded:
        return 'Refunded';
      case UserOrderPaymentStatus.pending:
        return 'Pending';
    }
  }

  List<UserOrderEntity> _getFilteredOrders(List<UserOrderEntity> orders) {
    return orders.where((order) {
      if (_selectedStatusFilter != null &&
          order.orderStatus != _selectedStatusFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final orderId = order.id?.toLowerCase() ?? '';
        final itemNames = order.items
            .map((item) => item.productName.toLowerCase())
            .join(' ');
        return orderId.contains(_searchQuery.toLowerCase()) ||
            itemNames.contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(userOrderViewModelProvider);
    final allOrders = orderState.orders;
    final filteredOrders = _getFilteredOrders(allOrders);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () async {
                    final didPop = await Navigator.of(context).maybePop();
                    if (!didPop && context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            title: Text(
              'My Orders',
              style: AppStyles.headline2.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          onChanged:
                              (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search orders...',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color:
                            _selectedStatusFilter != null
                                ? AppColors.primaryGreen.withOpacity(0.1)
                                : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              _selectedStatusFilter != null
                                  ? AppColors.primaryGreen
                                  : Colors.grey.shade200,
                        ),
                      ),
                      child: PopupMenuButton<UserOrderStatus?>(
                        tooltip: 'Filter by status',
                        icon: Icon(
                          Icons.filter_list,
                          color:
                              _selectedStatusFilter != null
                                  ? AppColors.primaryGreen
                                  : Colors.grey.shade600,
                          size: 20,
                        ),
                        onSelected: (status) {
                          setState(() {
                            _selectedStatusFilter = status;
                          });
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: null,
                                child: Text('All Orders'),
                              ),
                              ...UserOrderStatus.values.map(
                                (status) => PopupMenuItem(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getStatusIcon(status),
                                        color: _getStatusColor(status),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(_getStatusText(status)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (orderState.status == UserOrderViewStatus.loading &&
              allOrders.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
            ),

          if (filteredOrders.isEmpty &&
              orderState.status != UserOrderViewStatus.loading)
            SliverFillRemaining(child: _buildEmptyState()),

          if (filteredOrders.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final order = filteredOrders[index];
                  return _buildOrderCard(order);
                }, childCount: filteredOrders.length),
              ),
            ),

          if (orderState.status == UserOrderViewStatus.loading &&
              allOrders.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(UserOrderEntity order) {
    final statusColor = _getStatusColor(order.orderStatus);
    final statusIcon = _getStatusIcon(order.orderStatus);
    final statusText = _getStatusText(order.orderStatus);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final imageUrl = _getProductImageUrl(firstItem?.image);
    final itemCount = order.items.length;
    final uniqueItems = order.items.map((e) => e.productId).toSet().length;

    // These now use the enum versions
    final paymentStatus = order.paymentStatus;
    final paymentStatusColor = _getPaymentStatusColor(paymentStatus);
    final paymentStatusIcon = _getPaymentStatusIcon(paymentStatus);
    final paymentStatusText = _getPaymentStatusText(paymentStatus);
    final paymentMethod = _getPaymentMethodText(order.paymentMethod);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserOrderDetailScreen(orderId: order.id!),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt_outlined,
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ORDER #${order.id?.substring(order.id!.length - 8).toUpperCase()}',
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatRelativeDate(order.createdAt!),
                                style: AppStyles.caption.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.inventory_2,
                                size: 12,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                                style: AppStyles.caption.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: AppStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildProductPreview(imageUrl),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstItem?.productName ?? 'Product',
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (uniqueItems > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${uniqueItems - 1} more ${uniqueItems - 1 == 1 ? 'item' : 'items'}',
                                style: AppStyles.caption.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatCurrency(order.total),
                          style: AppStyles.bodyLarge.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total',
                          style: AppStyles.caption.copyWith(
                            color: Colors.grey.shade400,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: paymentStatusColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              paymentStatusIcon,
                              size: 14,
                              color: paymentStatusColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  paymentStatusText,
                                  style: AppStyles.caption.copyWith(
                                    color: paymentStatusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'via $paymentMethod',
                                  style: AppStyles.caption.copyWith(
                                    color: Colors.grey.shade500,
                                    fontSize: 9,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      constraints: const BoxConstraints(minWidth: 70),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Details',
                              style: AppStyles.caption.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 8,
                            color: AppColors.primaryGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductPreview(String? imageUrl) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child:
            imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                          color: AppColors.primaryGreen.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey.shade100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'No image',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                )
                : Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        color: AppColors.primaryGreen.withOpacity(0.5),
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Product',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.primaryGreen,
                  ),
                  Positioned(
                    bottom: 40,
                    right: 40,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search_off,
                        size: 24,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No orders yet!',
              style: AppStyles.headline2.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Looks like you haven\'t placed any orders. Start shopping to see your orders here!',
                style: AppStyles.bodyMedium.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.shopping_cart,
                  label: 'Shop Now',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.refresh,
                  label: 'Refresh',
                  onTap: () => _loadOrders(refresh: true),
                  isOutlined: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined ? Border.all(color: AppColors.primaryGreen) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isOutlined ? AppColors.primaryGreen : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isOutlined ? AppColors.primaryGreen : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
