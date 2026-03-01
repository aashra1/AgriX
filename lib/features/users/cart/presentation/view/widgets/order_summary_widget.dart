// lib/features/users/cart/presentation/widgets/order_summary_widget.dart
import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:flutter/material.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartEntity cart;
  final VoidCallback onCheckout;
  final double Function(double) calculateShipping;

  const OrderSummaryWidget({
    super.key,
    required this.cart,
    required this.onCheckout,
    required this.calculateShipping,
  });

  String _formatCurrency(double amount) {
    return 'Rs. ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.items.fold(0.0, (sum, item) => sum + item.itemTotal);
    final shipping = calculateShipping(subtotal);
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSummaryItems(subtotal, shipping),
          if (shipping == 0 && subtotal >= 1000) _buildFreeShippingBadge(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFEEEEEE)),
          ),
          _buildTotal(total),
          const SizedBox(height: 20),
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order Summary",
          style: AppStyles.headline2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${cart.totalItems} ${cart.totalItems == 1 ? 'item' : 'items'}',
            style: AppStyles.caption.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItems(double subtotal, double shipping) {
    return Column(
      children: [
        _SummaryRow(label: 'Subtotal', value: _formatCurrency(subtotal)),
        const SizedBox(height: 12),
        _SummaryRow(
          label: 'Shipping',
          value: shipping == 0 ? 'Free' : _formatCurrency(shipping),
          valueColor: shipping == 0 ? Colors.green : null,
        ),
      ],
    );
  }

  Widget _buildFreeShippingBadge() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Free shipping on orders over Rs. 1000",
              style: AppStyles.caption.copyWith(
                color: Colors.green[700],
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total",
          style: AppStyles.bodyLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          _formatCurrency(total),
          style: AppStyles.headline2.copyWith(
            fontSize: 24,
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: cart.items.isEmpty ? null : onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          "Proceed to Checkout",
          style: AppStyles.buttonText.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: AppColors.textGrey,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textBlack,
          ),
        ),
      ],
    );
  }
}
