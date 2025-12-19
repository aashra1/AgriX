import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/address.png",
                    width: 24,
                    height: 24,
                    color: Colors.black87,
                  ),

                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your location",
                        style: GoogleFonts.crimsonPro(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Bouddha, Kathmandu",
                        style: GoogleFonts.crimsonPro(
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/icons/bell.png",
                    width: 24,
                    height: 24,
                    color: Colors.black87,
                  ),

                  const SizedBox(width: 15),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                ],
              ),

              const SizedBox(height: 25),
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
                      padding: EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/icons/loupe-3.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    hintText: "Search for a product",
                    hintStyle: GoogleFonts.crimsonPro(color: Color(0xFF7B7979)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(height: 15),
              Text(
                "SHOP . TAP . GROW",
                style: GoogleFonts.crimsonPro(
                  color: Color(0xFF0B3D0B),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 230,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: SizedBox(
                        width: 156,
                        height: 51,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFDE7C),
                            foregroundColor: Color(0xff0B3D0B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Explore",
                            style: GoogleFonts.crimsonPro(
                              fontSize: 20,
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