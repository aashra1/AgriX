// lib/features/users/cart/presentation/widgets/cart_item_widget.dart
import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final bool isUpdating;
  final Function(String) onRemove;
  final Function(String, int) onUpdateQuantity;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.isUpdating,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  String _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/product-images/$fileName';
  }

  String _formatCurrency(double amount) {
    return 'Rs. ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getProductImageUrl(item.image);
    final discountedPrice = item.itemTotal / item.quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(imageUrl),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildBusinessName(),
                const SizedBox(height: 12),
                _buildPriceAndQuantity(discountedPrice),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imageUrl) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.imagePlaceholderGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                      ),
                )
                : Center(
                  child: Icon(
                    Icons.eco,
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    size: 40,
                  ),
                ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            item.name,
            style: AppStyles.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () => onRemove(item.productId),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.logoutRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.logoutRed,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item.businessName ?? 'Agrix',
        style: AppStyles.caption.copyWith(
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildPriceAndQuantity(double discountedPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildPriceSection(discountedPrice), _buildQuantityControl()],
    );
  }

  Widget _buildPriceSection(double discountedPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.discount > 0)
          Text(
            _formatCurrency(item.price),
            style: AppStyles.caption.copyWith(
              decoration: TextDecoration.lineThrough,
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        Text(
          _formatCurrency(discountedPrice),
          style: AppStyles.bodyLarge.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onPressed:
                () => onUpdateQuantity(item.productId, item.quantity - 1),
            disabled: isUpdating || item.quantity <= 1,
          ),
          Container(
            width: 32,
            alignment: Alignment.center,
            child:
                isUpdating
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      '${item.quantity}',
                      style: AppStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onPressed:
                () => onUpdateQuantity(item.productId, item.quantity + 1),
            disabled: isUpdating,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool disabled;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: disabled ? Colors.grey[100] : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: disabled ? Colors.grey[400] : AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }
}
