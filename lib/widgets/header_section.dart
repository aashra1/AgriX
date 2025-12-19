import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

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
              /// TOP ROW
              Row(
                children: [
                  Image.asset(
                    "assets/icons/address.png",
                    width: w * 0.06,
                    height: w * 0.06,
                    color: Colors.black87,
                  ),
                  SizedBox(width: w * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your location",
                        style: GoogleFonts.crimsonPro(
                          color: Colors.black,
                          fontSize: w * 0.04,
                        ),
                      ),
                      Text(
                        "Bouddha, Kathmandu",
                        style: GoogleFonts.crimsonPro(
                          color: const Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                          fontSize: w * 0.045,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/icons/bell.png",
                    width: w * 0.06,
                    height: w * 0.06,
                    color: Colors.black87,
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

              /// SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
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
                    hintStyle: GoogleFonts.crimsonPro(
                      color: const Color(0xFF7B7979),
                      fontSize: w * 0.04,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.02),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              /// TAGLINE
              Text(
                "SHOP . TAP . GROW",
                style: GoogleFonts.crimsonPro(
                  color: const Color(0xFF0B3D0B),
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: h * 0.03),

              /// BUTTON AREA
              SizedBox(
                height: h * 0.25,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: SizedBox(
                        width: w * 0.42,
                        height: h * 0.065,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFDE7C),
                            foregroundColor: const Color(0xff0B3D0B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Explore",
                            style: GoogleFonts.crimsonPro(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w500,
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
