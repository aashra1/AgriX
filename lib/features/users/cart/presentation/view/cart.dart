import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/cart/presentation/state/cart_state.dart';
import 'package:agrix/features/users/cart/presentation/view/widgets/cart_app_bar.dart';
import 'package:agrix/features/users/cart/presentation/view/widgets/cart_item_widget.dart';
import 'package:agrix/features/users/cart/presentation/view/widgets/empty_cart_widget.dart';
import 'package:agrix/features/users/cart/presentation/view/widgets/order_summary_widget.dart';
import 'package:agrix/features/users/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:agrix/features/users/checkout/presentation/view/checkout_screen.dart';
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
    final confirm = await _showConfirmationDialog(
      title: 'Remove Item',
      content: 'Remove this item from your cart?',
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

    final confirm = await _showConfirmationDialog(
      title: 'Clear Cart',
      content: 'Remove all items from your cart?',
    );

    if (confirm != true) return;

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    await ref.read(cartViewModelProvider.notifier).clearCart(token: token);
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logoutRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(title == 'Clear Cart' ? 'Clear' : 'Remove'),
              ),
            ],
          ),
    );
  }

  double _calculateShipping(double subtotal) {
    if (subtotal <= 0) return 0.0;
    if (subtotal >= 1000) return 0.0;
    return 85.0;
  }

  void _navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckoutScreen()),
    );
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
      appBar: CartAppBar(
        hasItems: cart != null && cart.items.isNotEmpty,
        onClearCart: _clearCart,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
              : cart == null || cart.items.isEmpty
              ? const EmptyCartWidget()
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        final isUpdating = _updatingItems.containsKey(
                          item.productId,
                        );
                        return CartItemWidget(
                          item: item,
                          isUpdating: isUpdating,
                          onRemove: _removeItem,
                          onUpdateQuantity: _updateQuantity,
                        );
                      },
                    ),
                  ),
                  OrderSummaryWidget(
                    cart: cart,
                    onCheckout: _navigateToCheckout,
                    calculateShipping: _calculateShipping,
                  ),
                ],
              ),
    );
  }
}
