import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/pages/business_add_product.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/pages/business_product_detail.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/state/business_product_state.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/viewmodel/business_product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessProductsList extends ConsumerStatefulWidget {
  const BusinessProductsList({super.key});

  @override
  ConsumerState<BusinessProductsList> createState() =>
      _BusinessProductsListState();
}

class _BusinessProductsListState extends ConsumerState<BusinessProductsList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await ref.read(userSessionServiceProvider).getToken();

      if (token != null) {
        ref
            .read(productViewModelProvider.notifier)
            .getBusinessProducts(token: token);
      } else {
        debugPrint("No token found. User might not be authenticated.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final productState = ref.watch(productViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1. Section Title and Add Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your products",
                style: GoogleFonts.crimsonPro(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusinessAddProductScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF3F3F3,
                    ), // Match grey button background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 24, color: Colors.black),
                ),
              ),
            ],
          ),
        ),

        /// 2. Product Grid
        _buildProductGrid(productState, w),
      ],
    );
  }

  Widget _buildProductGrid(ProductState state, double w) {
    if (state.status == ProductStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0B3D0B)),
        ),
      );
    }

    final products = state.products;

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            "No products added yet.",
            style: GoogleFonts.crimsonPro(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusinessProductDetails(product: product),
              ),
            );
          },
          child: _buildProductCard(product), // Calls the UI-only method below
        );
      },
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    final String fileName = product.image?.split('/').last ?? "";

    final String fullImageUrl = "${ApiEndpoints.imageUrl}/$fileName";

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child:
                  fileName.isNotEmpty
                      ? Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          );
                        },
                      )
                      : const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                        size: 40,
                      ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: GoogleFonts.crimsonPro(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
