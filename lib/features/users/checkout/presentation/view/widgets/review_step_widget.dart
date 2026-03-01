import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/checkout/domain/entity/checkout_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewStepWidget extends StatelessWidget {
  final CartEntity cart;
  final AddressEntity address;
  final PaymentMethod paymentMethod;
  final VoidCallback onBack;
  final VoidCallback onPlaceOrder;
  final bool isProcessing;
  final bool isKhaltiProcessing;

  const ReviewStepWidget({
    super.key,
    required this.cart,
    required this.address,
    required this.paymentMethod,
    required this.onBack,
    required this.onPlaceOrder,
    required this.isProcessing,
    required this.isKhaltiProcessing,
  });

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: 'Rs. ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/product-images/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Review',
          style: AppStyles.bodyLarge.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Items List
        _buildCompactItemsList(),
        const SizedBox(height: 20),

        // Info Grid (Address & Payment)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoCard(
                'Shipping to',
                address.fullName,
                address.addressLine1,
                Icons.local_shipping_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Payment via',
                paymentMethod == PaymentMethod.cod ? 'Cash' : 'Khalti',
                'Secure Transaction',
                Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildCompactItemsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.imagePlaceholderGrey.withOpacity(0.5),
        ),
      ),
      child: Column(
        children:
            cart.items.take(3).map((item) {
              // Taking 3 to keep it compact, scroll handles the rest
              final imageUrl = _getProductImageUrl(item.image);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          imageUrl.isNotEmpty
                              ? Image.network(
                                imageUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 40,
                                height: 40,
                                color: AppColors.imagePlaceholderGrey,
                                child: const Icon(Icons.eco, size: 20),
                              ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppStyles.bodyMedium.copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('x${item.quantity}', style: AppStyles.caption),
                    const SizedBox(width: 12),
                    Text(
                      _formatCurrency(item.itemTotal),
                      style: AppStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildInfoCard(String label, String title, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppStyles.caption.copyWith(
              fontSize: 10,
              color: AppColors.textLightGrey,
            ),
          ),
          Text(
            title,
            style: AppStyles.bodyMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
          Text(
            sub,
            style: AppStyles.caption.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool isLoading = isProcessing || isKhaltiProcessing;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPlaceOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      paymentMethod == PaymentMethod.cod
                          ? 'Confirm & Place Order'
                          : 'Pay with Khalti',
                      style: AppStyles.buttonText.copyWith(color: Colors.white),
                    ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onBack,
          child: Text(
            'Change payment method',
            style: AppStyles.caption.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
