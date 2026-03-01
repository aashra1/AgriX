import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/order/presentation/state/user_order_state.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/action_buttons.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/loading_error_widgets.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/order_detail_app_bar.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/order_items_section.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/order_status_card.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/order_summary_card.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/payment_info_card.dart';
import 'package:agrix/features/users/order/presentation/view/widgets/shipping_address_card.dart';
import 'package:agrix/features/users/order/presentation/viewmodel/user_order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserOrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const UserOrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<UserOrderDetailScreen> createState() =>
      _UserOrderDetailScreenState();
}

class _UserOrderDetailScreenState extends ConsumerState<UserOrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOrderDetails());
  }

  Future<void> _loadOrderDetails() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }
    await ref
        .read(userOrderViewModelProvider.notifier)
        .getOrderById(token: token, orderId: widget.orderId);
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: 'रू ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  String _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/product-images/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(userOrderViewModelProvider);
    final order = orderState.currentOrder;

    ref.listen<UserOrderState>(userOrderViewModelProvider, (previous, next) {
      if (next.status == UserOrderViewStatus.error &&
          next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
      }
    });

    if (orderState.status == UserOrderViewStatus.loading && order == null) {
      return const LoadingScreen();
    }

    if (order == null) {
      return ErrorScreen(onBackPressed: () => Navigator.pop(context));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          OrderDetailAppBar(
            order: order,
            formatDateTime: _formatDateTime,
            onBackPressed: () => Navigator.pop(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderStatusCard(order: order, formatDate: _formatDate),
                  const SizedBox(height: 20),
                  OrderItemsSection(
                    order: order,
                    formatCurrency: _formatCurrency,
                    getProductImageUrl: _getProductImageUrl,
                  ),
                  const SizedBox(height: 20),
                  OrderSummaryCard(
                    order: order,
                    formatCurrency: _formatCurrency,
                  ),
                  const SizedBox(height: 20),
                  ShippingAddressCard(order: order),
                  const SizedBox(height: 20),
                  PaymentInfoCard(
                    order: order,
                    formatCurrency: _formatCurrency,
                  ),
                  const SizedBox(height: 32),
                  ActionButtons(
                    onSharePressed: () {
                      // Handle share
                    },
                    onBackPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
