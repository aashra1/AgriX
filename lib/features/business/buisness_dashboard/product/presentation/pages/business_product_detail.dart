import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/pages/business_edit_product.dart';
import 'package:flutter/material.dart';

class BusinessProductDetails extends StatelessWidget {
  final ProductEntity product;

  const BusinessProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final fileName = product.image?.split('/').last ?? "";
    final imageUrl = "${ApiEndpoints.baseIp}/uploads/product-images/$fileName";

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: h * 0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.imagePlaceholderGrey,
                        image:
                            fileName.isNotEmpty
                                ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          fileName.isEmpty
                              ? const Icon(
                                Icons.shopping_bag_outlined,
                                size: 80,
                                color: AppColors.iconGrey,
                              )
                              : null,
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.06,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.categoryName?.toUpperCase() ?? "MACHINERY",
                            style: AppStyles.caption.copyWith(
                              color: AppColors.secondaryGreen,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 12,
                            ),
                          ),
                          if (product.brand != null)
                            Text(
                              product.brand!,
                              style: AppStyles.bodyMedium.copyWith(
                                color: AppColors.textGrey,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        style: AppStyles.headline1.copyWith(
                          fontSize: 24,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price",
                                  style: AppStyles.caption.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  "NPR ${product.price}",
                                  style: AppStyles.bodyLarge.copyWith(
                                    fontSize: 20,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (product.discount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryYellow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${product.discount}% OFF",
                                  style: AppStyles.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildQuickSpec(
                            Icons.inventory_2_outlined,
                            "Stock",
                            "${product.stock}",
                          ),
                          const SizedBox(width: 12),
                          _buildQuickSpec(
                            Icons.scale_outlined,
                            "Weight",
                            "${product.weight} ${product.unitType}",
                          ),
                        ],
                      ),
                      const Divider(
                        height: 48,
                        thickness: 1,
                        color: AppColors.backgroundGrey,
                      ),
                      _buildSectionTitle("Description"),
                      const SizedBox(height: 10),
                      Text(
                        product.fullDescription ?? "No description available.",
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textBlack.withOpacity(0.7),
                          height: 1.5,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildCircleButton(
                      icon: Icons.edit_note_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    BusinessEditProductScreen(product: product),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
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
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textBlack, size: 18),
      ),
    );
  }

  Widget _buildQuickSpec(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.backgroundGrey),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondaryGreen, size: 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppStyles.caption.copyWith(fontSize: 10)),
                Text(
                  value,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppStyles.bodyLarge.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
