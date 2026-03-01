import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  const AppStyles._();

  static TextStyle headline1 = GoogleFonts.crimsonPro(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.textBlack,
  );

  static TextStyle headline2 = GoogleFonts.crimsonPro(
    fontSize: 35,
    fontWeight: FontWeight.w800,
    color: AppColors.textBlack,
  );

  static TextStyle bodyLarge = GoogleFonts.crimsonPro(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static TextStyle bodyMedium = GoogleFonts.crimsonPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
  );

  static TextStyle sidebarItem = GoogleFonts.crimsonPro(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
  );

  static TextStyle sidebarItemActive = GoogleFonts.crimsonPro(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.sidebarAccent,
  );

  static TextStyle sidebarLogout = GoogleFonts.crimsonPro(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.logoutRed,
  );

  static TextStyle buttonText = GoogleFonts.crimsonPro(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryGreen,
  );

  static TextStyle caption = GoogleFonts.crimsonPro(
    fontSize: 11,
    color: AppColors.textGrey,
  );

  static TextStyle formTitle = GoogleFonts.crimsonPro(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static TextStyle inputField = GoogleFonts.crimsonPro(
    color: AppColors.hintTextBlue,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static TextStyle bodyText1 = GoogleFonts.crimsonPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
    height: 1.5,
  );

  static TextStyle bodyText2 = GoogleFonts.crimsonPro(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textBlack,
    height: 1.43,
  );
}
