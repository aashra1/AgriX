import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/state/business_order_state.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/view/business_order_detail_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/viewmodel/business_order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BusinessOrdersPage extends ConsumerStatefulWidget {
  const BusinessOrdersPage({super.key});

  @override
  ConsumerState<BusinessOrdersPage> createState() => _BusinessOrdersPageState();
}

class _BusinessOrdersPageState extends ConsumerState<BusinessOrdersPage> {
  String _statusFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders({bool refresh = false}) async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    final businessId = ref.read(userSessionServiceProvider).getCurrentauthId();
    if (token == null || businessId == null) return;
    if (refresh) _currentPage = 1;

    await ref
        .read(businessOrderViewModelProvider.notifier)
        .getBusinessOrders(
          token: token,
          businessId: businessId,
          page: _currentPage,
          limit: 10,
          refresh: refresh,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(businessOrderViewModelProvider);
      if (!state.hasReachedMax && !_isLoadingMore) _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    final businessId = ref.read(userSessionServiceProvider).getCurrentauthId();
    if (token == null || businessId == null) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
    await ref
        .read(businessOrderViewModelProvider.notifier)
        .getBusinessOrders(
          token: token,
          businessId: businessId,
          page: _currentPage,
          limit: 10,
        );
    setState(() => _isLoadingMore = false);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF2D6A4F);
      case 'shipped':
        return const Color(0xFF2A9D8F);
      case 'processing':
        return const Color(0xFF7209B7);
      case 'pending':
        return const Color(0xFFE9C46A);
      case 'cancelled':
        return AppColors.logoutRed;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(businessOrderViewModelProvider);
    final filteredOrders =
        orderState.orders.where((order) {
          final matchesStatus =
              _statusFilter == 'all' ||
              order.orderStatus.toString().split('.').last.toLowerCase() ==
                  _statusFilter.toLowerCase();
          final query = _searchQuery.toLowerCase();
          return matchesStatus &&
              (_searchQuery.isEmpty ||
                  (order.id?.toLowerCase().contains(query) ?? false) ||
                  (order.userFullName?.toLowerCase().contains(query) ?? false));
        }).toList();

    ref.listen<BusinessOrderState>(businessOrderViewModelProvider, (
      prev,
      next,
    ) {
      if (next.status == BusinessOrderStatus.updated) {
        showSnackBar(
          context: context,
          message: 'Status updated successfully',
          isSuccess: true,
        );
        ref.read(businessOrderViewModelProvider.notifier).resetStatus();
      }
    });

    return Column(
      children: [
        _buildTopFilterSection(),
        Expanded(
          child:
              orderState.status == BusinessOrderStatus.loading &&
                      filteredOrders.isEmpty
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                  : filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                    onRefresh: () => _loadOrders(refresh: true),
                    color: AppColors.primaryGreen,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          filteredOrders.length + (_isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == filteredOrders.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return _orderCard(filteredOrders[index]);
                      },
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildTopFilterSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            style: AppStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: "Search ID or Customer...",
              hintStyle: AppStyles.caption,
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: AppColors.primaryGreen,
              ),
              filled: true,
              fillColor: AppColors.backgroundGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    'all',
                    'pending',
                    'processing',
                    'shipped',
                    'delivered',
                    'cancelled',
                  ].map((status) {
                    final isSelected = _statusFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          status.toUpperCase(),
                          style: AppStyles.caption.copyWith(
                            fontSize: 10,
                            color:
                                isSelected ? Colors.white : AppColors.textBlack,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: AppColors.backgroundGrey,
                        showCheckmark: false,
                        onSelected:
                            (val) => setState(() => _statusFilter = status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(BusinessOrderEntity order) {
    final statusString = order.orderStatus.toString().split('.').last;

    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BusinessOrderDetailScreen(orderId: order.id!),
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#${order.id?.substring(order.id!.length - 8).toUpperCase()}",
                        style: AppStyles.bodyLarge,
                      ),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(order.createdAt ?? DateTime.now()),
                        style: AppStyles.caption,
                      ),
                    ],
                  ),
                  _statusBadge(statusString),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                    child: Text(
                      order.userFullName?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.userFullName ?? "Guest User",
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          order.userPhone ?? "No contact",
                          style: AppStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "NPR ${order.total.toStringAsFixed(2)}",
                    style: AppStyles.bodyLarge.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: statusString.toLowerCase(),
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primaryGreen,
                  ),
                  items:
                      [
                        'pending',
                        'processing',
                        'shipped',
                        'delivered',
                        'cancelled',
                      ].map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(
                            s.toUpperCase(),
                            style: AppStyles.sidebarItem.copyWith(fontSize: 11),
                          ),
                        );
                      }).toList(),
                  onChanged: (newStatus) async {
                    if (newStatus != null && newStatus != statusString) {
                      final token =
                          await ref.read(userSessionServiceProvider).getToken();
                      ref
                          .read(businessOrderViewModelProvider.notifier)
                          .updateOrderStatus(
                            orderId: order.id!,
                            orderStatus: newStatus,
                            token: token!,
                          );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text("No orders yet", style: AppStyles.bodyLarge),
        ],
      ),
    );
  }
}
