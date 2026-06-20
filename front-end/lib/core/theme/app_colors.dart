import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF0F5FA);
  static const Color primaryGreen = Color(0xFF66BB6A);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color darkBrown = Color(0xFF6D4C41);
  static const Color brown = Color(0xFFA1887F);
  static const Color lightGray = Color(0xFFEFEFF0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF0000);
  static const Color yellowStar = Color(0xFFEF9F27);
  static const Color darkBackground = Color(0xFF171C20);
  static const Color deepGreen = Color(0xFF126D27);
}

String formatRupiah(int amount) {
  return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.darkBrown,
  );

  static const TextStyle priceGreen = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryGreen,
  );
}