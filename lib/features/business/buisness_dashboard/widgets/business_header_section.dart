import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/pages/business_add_product.dart';
import 'package:flutter/material.dart';

class BusinessHeaderSection extends StatelessWidget {
  const BusinessHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/header.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Removed the menu icon GestureDetector

                  // Keep location info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your location",
                        style: AppStyles.caption.copyWith(
                          color: AppColors.textBlack,
                        ),
                      ),
                      Text(
                        "Bouddha, Kathmandu",
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.secondaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Keep notification bell and profile
                  Image.asset(
                    "assets/icons/bell.png",
                    width: w * 0.06,
                    height: w * 0.06,
                    color: AppColors.textBlack,
                  ),
                  SizedBox(width: w * 0.04),
                  CircleAvatar(
                    radius: w * 0.045,
                    backgroundImage: const AssetImage(
                      "assets/images/profile.jpg",
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),

              // Search field
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  style: AppStyles.bodyMedium,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(w * 0.03),
                      child: Image.asset(
                        'assets/icons/loupe-3.png',
                        width: w * 0.06,
                        height: w * 0.06,
                      ),
                    ),
                    hintText: "Search for a product",
                    hintStyle: AppStyles.inputField.copyWith(
                      color: AppColors.textGrey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.02),
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),

              // Tagline
              Text(
                "SHOP . TAP . GROW",
                style: AppStyles.bodyLarge.copyWith(
                  color: AppColors.primaryGreen,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: h * 0.03),

              // Add Products button
              SizedBox(
                height: h * 0.15,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: SizedBox(
                        width: w * 0.42,
                        height: h * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const BusinessAddProductScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            foregroundColor: AppColors.primaryGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Add Products",
                            style: AppStyles.buttonText.copyWith(
                              fontSize: w * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
