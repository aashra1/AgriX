import 'package:agrix/features/auth/signup/signup.dart';
import 'package:agrix/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 122,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo-2.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.crimsonPro(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Please enter your details',
                        style: GoogleFonts.crimsonPro(
                          color: const Color(0xFF777777),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
                          labelText: 'Email',
                          labelStyle: GoogleFonts.crimsonPro(
                            fontSize: 20,
                            color: const Color(0xFF777777),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/icons/email.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
                          labelText: 'Password',
                          labelStyle: GoogleFonts.crimsonPro(
                            fontSize: 22,
                            color: const Color(0xFF777777),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/icons/password.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.crimsonPro(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B3D0B),
                          minimumSize: const Size(230, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.crimsonPro(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // RichText(
                      //   textAlign: TextAlign.center,
                      //   text: TextSpan(
                      //     text: "Don't have an account? ",
                      //     style: GoogleFonts.crimsonPro(
                      //       fontSize: 16,
                      //       color: const Color(0xFF7B7979),
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: 'Signup!',
                      //         style: GoogleFonts.crimsonPro(
                      //           fontSize: 16,
                      //           color: Colors.red,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),


                      //richtext
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.crimsonPro(
                              fontSize: 16,
                              color: const Color(0xFF7B7979),
                            ),
                          ),
                          SizedBox(width: 2),
                          GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                ),
                            child: Text(
                              "Signup!",
                              style: GoogleFonts.crimsonPro(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
