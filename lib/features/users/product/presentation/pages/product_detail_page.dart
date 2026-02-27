import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/cart/presentation/state/cart_state.dart';
import 'package:agrix/features/users/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:agrix/features/users/product/presentation/state/user_product_state.dart';
import 'package:agrix/features/users/product/presentation/viewmodel/user_product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProductDetails();
    });
  }

  Future<void> _loadProductDetails() async {
    await ref
        .read(userProductViewModelProvider.notifier)
        .getProductById(productId: widget.productId);
  }

  String _getProductImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/product-images/$fileName';
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: 'Rs. ',
      decimalDigits: 0,
    ).format(amount);
  }

  Future<void> _addToCart() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    final productState = ref.read(userProductViewModelProvider);
    final product = productState.selectedProduct;
    if (product == null) return;

    setState(() {
      _isAddingToCart = true;
    });

    await ref
        .read(cartViewModelProvider.notifier)
        .addToCart(token: token, productId: product.id!, quantity: _quantity);

    setState(() {
      _isAddingToCart = false;
    });
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Please login to add items to cart',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, '/login');
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(userProductViewModelProvider);
    final product = productState.selectedProduct;
    final isLoading = productState.status == UserProductStatus.loading;

    ref.listen<CartState>(cartViewModelProvider, (previous, next) {
      if (next.status == CartStatus.error && next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
      } else if (next.status == CartStatus.updated) {
        showSnackBar(
          context: context,
          message: 'Added to cart successfully!',
          isSuccess: true,
        );
        ref.read(cartViewModelProvider.notifier).resetStatus();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
              : product == null
              ? const Center(child: Text("Product not found"))
              : Stack(
                children: [
                  // Scrollable Content
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Large Image Header
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: double.infinity,
                          child: _buildProductImage(product),
                        ),

                        // 2. Details Container
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Price Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: AppStyles.headline2.copyWith(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _formatCurrency(
                                      product.discount > 0
                                          ? product.discountedPrice
                                          : product.price,
                                    ),
                                    style: AppStyles.headline2.copyWith(
                                      fontSize: 22,
                                      color: const Color(0xFFFACC15),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Business Name
                              if (product.businessName != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryGreen
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          product.businessName!,
                                          style: AppStyles.caption.copyWith(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Quantity Selector
                              Row(
                                children: [
                                  Text(
                                    "Quantity:",
                                    style: AppStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 18,
                                          ),
                                          onPressed: _decreaseQuantity,
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$_quantity',
                                            style: AppStyles.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 18),
                                          onPressed: _increaseQuantity,
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Description Title
                              Text(
                                "About Product",
                                style: AppStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Description Body
                              Text(
                                product.fullDescription ??
                                    product.shortDescription ??
                                    'No description available.',
                                style: AppStyles.bodyMedium.copyWith(
                                  height: 1.6,
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(
                                height: 100,
                              ), // Space for bottom floating bar
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Floating Custom Back Button
                  Positioned(
                    top: 50,
                    left: 20,
                    child: _buildCircleButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),

                  // 4. Floating Action Bar (Bottom)
                  Positioned(
                    bottom: 30,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        // Add to Cart "Pill"
                        _buildAddToCartButton(),
                        const SizedBox(width: 16),
                        // Buy Now Primary Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Buy now logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B3C1B),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Buy Now",
                              style: AppStyles.buttonText.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return GestureDetector(
      onTap: _isAddingToCart ? null : _addToCart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F1),
          borderRadius: BorderRadius.circular(30),
        ),
        child:
            _isAddingToCart
                ? const SizedBox(
                  width: 80,
                  height: 22,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1B3C1B),
                      strokeWidth: 2,
                    ),
                  ),
                )
                : Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF1B3C1B),
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Add to cart",
                      style: AppStyles.bodyMedium.copyWith(
                        color: const Color(0xFF1B3C1B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildProductImage(UserProductEntity product) {
    final imageUrl = _getProductImageUrl(product.image);
    return imageUrl.isNotEmpty
        ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                color: const Color(0xFFF2F2F2),
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
        )
        : Container(
          color: const Color(0xFFF2F2F2),
          child: const Icon(Icons.image, size: 80, color: Colors.grey),
        );
  }
}
