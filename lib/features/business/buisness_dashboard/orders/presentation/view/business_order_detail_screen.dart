import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/state/business_order_state.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/viewmodel/business_order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BusinessOrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  const BusinessOrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<BusinessOrderDetailScreen> createState() =>
      _BusinessOrderDetailScreenState();
}

class _BusinessOrderDetailScreenState
    extends ConsumerState<BusinessOrderDetailScreen> {
  String? _selectedStatus;
  bool _isUpdating = false;
  String? _trackingNumber;
  final TextEditingController _trackingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  Future<void> _loadOrderDetails() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      showSnackBar(
        context: context,
        message: 'Authentication required',
        isSuccess: false,
      );
      return;
    }

    await ref
        .read(businessOrderViewModelProvider.notifier)
        .getOrderById(orderId: widget.orderId, token: token);
  }

  Future<void> _refreshOrder() async {
    await _loadOrderDetails();
  }

  String _getPaymentStatusDisplay(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return 'COMPLETED';
      case PaymentStatus.failed:
        return 'FAILED';
      case PaymentStatus.pending:
        return 'PENDING';
    }
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.pending:
        return Colors.orange;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(double amount) =>
      NumberFormat.currency(symbol: 'NPR ', decimalDigits: 2).format(amount);

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  String _getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return "${ApiEndpoints.baseIp}/uploads/product-images/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(businessOrderViewModelProvider);
    final order = orderState.selectedOrder;

    ref.listen<BusinessOrderState>(businessOrderViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == BusinessOrderStatus.error) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? 'An error occurred',
          isSuccess: false,
        );
        setState(() => _isUpdating = false);
      } else if (next.status == BusinessOrderStatus.updated) {
        showSnackBar(
          context: context,
          message: 'Order updated successfully',
          isSuccess: true,
        );
        setState(() => _isUpdating = false);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ref.read(businessOrderViewModelProvider.notifier).resetStatus();
          }
        });
      }
    });

    if (orderState.status == BusinessOrderStatus.loading && order == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          title: const Text("Order Details"),
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text(
                "Order not found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "The order you're looking for doesn't exist",
                style: TextStyle(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    final statusString = order.orderStatus.toString().split('.').last;
    _selectedStatus ??= statusString;
    _trackingNumber ??= order.trackingNumber;
    _trackingController.text = _trackingNumber ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text(
          order.id != null
              ? "Order #${order.id!.substring(order.id!.length - 8)}"
              : "Order Details",
          style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primaryGreen),
            onPressed: _refreshOrder,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(order, statusString),
            const SizedBox(height: 20),
            _buildTimeline(order, statusString),
            const SizedBox(height: 20),
            _buildSectionHeader(Icons.inventory_2_outlined, "Order Items"),
            ...order.items.map((item) => _buildOrderItem(item)),
            _buildPriceSummary(order),
            const SizedBox(height: 20),
            _buildSectionHeader(
              Icons.local_shipping_outlined,
              "Shipping Information",
            ),
            _buildCustomerCard(order),
            const SizedBox(height: 20),
            _buildSectionHeader(Icons.payment_outlined, "Payment Details"),
            _buildPaymentCard(order),
            const SizedBox(height: 20),
            if (order.notes != null && order.notes!.isNotEmpty)
              _buildNotesSection(order),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BusinessOrderEntity order, String currentStatus) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(currentStatus).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(currentStatus).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Status",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusBadge(currentStatus),
              if (order.updatedAt != null)
                Text(
                  "Updated: ${_formatDate(order.updatedAt)}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
            ],
          ),
          const Divider(height: 24),
          const Text(
            "Update Status",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (_selectedStatus == 'shipped')
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _trackingController,
                onChanged: (val) => _trackingNumber = val,
                decoration: InputDecoration(
                  labelText: 'Tracking Number',
                  hintText: 'Enter tracking number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getStatusColor(s),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                s.toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (val) => setState(() => _selectedStatus = val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed:
                    (_selectedStatus == currentStatus &&
                                _trackingNumber == order.trackingNumber) ||
                            _isUpdating
                        ? null
                        : _updateOrderStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child:
                    _isUpdating
                        ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateOrderStatus() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      showSnackBar(
        context: context,
        message: 'Authentication required',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isUpdating = true);

    await ref
        .read(businessOrderViewModelProvider.notifier)
        .updateOrderStatus(
          orderId: widget.orderId,
          orderStatus: _selectedStatus!,
          trackingNumber: _trackingNumber,
          token: token,
        );
  }

  Widget _buildTimeline(BusinessOrderEntity order, String currentStatus) {
    final steps = ['pending', 'processing', 'shipped', 'delivered'];
    int currentIdx = steps.indexOf(currentStatus.toLowerCase());
    if (currentIdx == -1) currentIdx = 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(steps.length, (index) {
          bool isDone = index <= currentIdx;
          bool isCurrent = index == currentIdx;

          return Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDone ? AppColors.primaryGreen : Colors.grey.shade300,
                  ),
                  child: Icon(
                    isDone ? Icons.check : Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index].toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isDone ? AppColors.primaryGreen : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderItem(BusinessOrderItemEntity item) {
    final imageUrl = _getImageUrl(item.image);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.imagePlaceholderGrey,
              image:
                  imageUrl.isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                imageUrl.isEmpty
                    ? const Icon(
                      Icons.image_not_supported,
                      size: 20,
                      color: AppColors.iconGrey,
                    )
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Qty: ${item.quantity} x ${_formatCurrency(item.price)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (item.discount > 0)
                  Text(
                    "Discount: ${item.discount}%",
                    style: const TextStyle(fontSize: 11, color: Colors.green),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(item.price * item.quantity),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontSize: 14,
                ),
              ),
              if (item.discount > 0)
                Text(
                  _formatCurrency(
                    (item.price * item.quantity) * (1 - item.discount / 100),
                  ),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BusinessOrderEntity order) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal", _formatCurrency(order.subtotal)),
          _summaryRow("Shipping", _formatCurrency(order.shipping)),
          _summaryRow("Tax", _formatCurrency(order.tax)),
          const Divider(height: 16),
          _summaryRow("Total", _formatCurrency(order.total), isBold: true),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(BusinessOrderEntity order) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                  radius: 20,
                  child: Text(
                    (order.userFullName?.isNotEmpty ?? false)
                        ? order.userFullName![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.userFullName ?? "Unknown Customer",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (order.userEmail != null)
                        Text(
                          order.userEmail!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      if (order.userPhone != null)
                        Text(
                          order.userPhone!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              "Shipping Address",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              order.shippingAddress.fullName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(order.shippingAddress.addressLine1),
            if (order.shippingAddress.addressLine2 != null)
              Text(order.shippingAddress.addressLine2!),
            Text(
              "${order.shippingAddress.city}, ${order.shippingAddress.state} ${order.shippingAddress.postalCode}",
            ),
            const SizedBox(height: 4),
            Text("Phone: ${order.shippingAddress.phone}"),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BusinessOrderEntity order) {
    final paymentStatus = order.paymentStatus;
    final statusDisplay = _getPaymentStatusDisplay(paymentStatus);
    final statusColor = _getPaymentStatusColor(paymentStatus);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment Information",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusDisplay,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Method",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            order.paymentMethod == PaymentMethod.cod
                                ? Icons.money
                                : order.paymentMethod == PaymentMethod.khalti
                                ? Icons.bolt
                                : Icons.credit_card,
                            size: 16,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.paymentMethod
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(order.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (order.trackingNumber != null &&
                order.trackingNumber!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tracking Number",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.trackingNumber!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BusinessOrderEntity order) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.note_outlined,
                  size: 20,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Order Notes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(order.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 14 : 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppColors.primaryGreen : Colors.black,
              fontSize: isBold ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
