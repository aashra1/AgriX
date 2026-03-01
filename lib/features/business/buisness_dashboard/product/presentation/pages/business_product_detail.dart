import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessProductDetails extends StatelessWidget {
  final ProductEntity product;

  const BusinessProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Clean image URL logic
    final fileName = product.image?.split('/').last ?? "";
    final imageUrl = "${ApiEndpoints.baseIp}/uploads/product-images/$fileName";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Product Details",
          style: GoogleFonts.crimsonPro(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              /* Logic for Edit */
            },
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF0B3D0B)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Product Image Header
            Container(
              height: h * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
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
                        size: 100,
                        color: Colors.grey,
                      )
                      : null,
            ),

            Padding(
              padding: EdgeInsets.all(w * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 2. Category & Name
                  Text(
                    product.categoryName?.toUpperCase() ?? "MACHINERY",
                    style: GoogleFonts.crimsonPro(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 3. Price & Stock Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            "NPR ${product.price}",
                            style: GoogleFonts.crimsonPro(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0B3D0B),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B3D0B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Stock: ${product.stock}",
                          style: GoogleFonts.crimsonPro(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0B3D0B),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 40),

                  /// 4. Specifications (Weight/Unit)
                  _buildSectionTitle("Specifications"),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    "Weight",
                    "${product.weight} ${product.unitType}",
                  ),

                  const SizedBox(height: 25),

                  /// 5. Description
                  _buildSectionTitle("Description"),
                  const SizedBox(height: 10),
                  Text(
                    product.fullDescription ?? "No description available.",
                    style: GoogleFonts.crimsonPro(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.crimsonPro(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
