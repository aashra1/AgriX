import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/cart/presentation/state/cart_state.dart';
import 'package:agrix/features/users/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:agrix/features/users/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = true;
  final Map<String, int> _updatingItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCart();
    });
  }

  Future<void> _loadCart() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }
    await ref.read(cartViewModelProvider.notifier).getCart(token: token);
  }

  void _showAuthError() {
    setState(() => _isLoading = false);
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  String _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/product-images/$fileName';
  }

  String _formatCurrency(double amount) {
    return 'Rs. ${amount.toStringAsFixed(0)}';
  }

  Future<void> _updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 1) return;

    setState(() {
      _updatingItems[productId] = newQuantity;
    });

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    await ref
        .read(cartViewModelProvider.notifier)
        .updateCartItem(
          token: token,
          productId: productId,
          quantity: newQuantity,
        );

    setState(() {
      _updatingItems.remove(productId);
    });
  }

  Future<void> _removeItem(String productId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Item'),
            content: const Text(
              'Are you sure you want to remove this item from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logoutRed,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    await ref
        .read(cartViewModelProvider.notifier)
        .removeFromCart(token: token, productId: productId);
  }

  Future<void> _clearCart() async {
    final cartState = ref.read(cartViewModelProvider);
    if (cartState.cart?.items.isEmpty ?? true) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logoutRed,
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    await ref.read(cartViewModelProvider.notifier).clearCart(token: token);
  }

  double _calculateShipping(double subtotal) {
    if (subtotal <= 0) return 0.0;
    if (subtotal >= 1000) return 0.0;
    return 85.0;
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final cart = cartState.cart;
    final isLoading = cartState.status == CartStatus.loading && _isLoading;

    ref.listen<CartState>(cartViewModelProvider, (previous, next) {
      if (next.status == CartStatus.error && next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
      } else if (next.status == CartStatus.updated) {
        setState(() => _isLoading = false);
        ref.read(cartViewModelProvider.notifier).resetStatus();
      } else if (next.status == CartStatus.loaded) {
        setState(() => _isLoading = false);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("My Cart", style: AppStyles.bodyLarge),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.imagePlaceholderGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textBlack,
                size: 20,
              ),
            ),
          ),
        ),
        actions: [
          if (cart != null && cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.logoutRed,
              ),
              onPressed: _clearCart,
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
              : cart == null || cart.items.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: AppStyles.bodyLarge.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to get started',
                        style: AppStyles.caption.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Continue Shopping',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: cart.items.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        final isUpdating = _updatingItems.containsKey(
                          item.productId,
                        );
                        return _buildCartItem(item, isUpdating);
                      },
                    ),
                  ),
                  _buildOrderSummary(cart),
                ],
              ),
    );
  }

  Widget _buildCartItem(CartItemEntity item, bool isUpdating) {
    final imageUrl = _getProductImageUrl(item.image);
    final itemTotal = item.itemTotal;
    final discountedPrice = itemTotal / item.quantity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textBlack.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Section
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.imagePlaceholderGrey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
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
          ),
          const SizedBox(width: 16),
          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppStyles.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.discount > 0)
                      Text(
                        _formatCurrency(item.price),
                        style: AppStyles.caption.copyWith(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    Text(
                      _formatCurrency(discountedPrice),
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.businessName ?? 'Agrix',
                        style: AppStyles.caption.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _removeItem(item.productId),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.logoutRed,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Vertical Quantity Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _qtyBtn(
                  Icons.add,
                  () => _updateQuantity(item.productId, item.quantity + 1),
                  isUpdating,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child:
                      isUpdating
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            '${item.quantity}',
                            style: AppStyles.inputField,
                          ),
                ),
                _qtyBtn(
                  Icons.remove,
                  () => _updateQuantity(item.productId, item.quantity - 1),
                  isUpdating || item.quantity <= 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed, bool disabled) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey[200] : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              disabled
                  ? null
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: disabled ? Colors.grey[400] : AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartEntity cart) {
    final subtotal = cart.items.fold(0.0, (sum, item) => sum + item.itemTotal);
    final shipping = _calculateShipping(subtotal);
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Summary",
                style: AppStyles.headline2.copyWith(fontSize: 24),
              ),
              ElevatedButton(
                onPressed:
                    cart.items.isEmpty
                        ? null
                        : () {
                          // Navigate to checkout
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Checkout",
                  style: AppStyles.buttonText.copyWith(
                    color: AppColors.backgroundWhite,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _summaryItem(
            "Subtotal (${cart.totalItems} items)",
            _formatCurrency(subtotal),
          ),
          const SizedBox(height: 12),
          _summaryItem(
            "Shipping",
            shipping == 0 ? "Free" : _formatCurrency(shipping),
          ),
          if (shipping == 0 && subtotal >= 1000)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
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
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.imagePlaceholderGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: AppStyles.bodyLarge),
              Text(
                _formatCurrency(total),
                style: AppStyles.headline2.copyWith(
                  fontSize: 22,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(color: AppColors.textGrey),
        ),
        Text(
          value,
          style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
