import 'package:chat_app/presentation/theme/app_colors.dart';
import 'package:chat_app/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';

mixin AppTheme {
  static ThemeData dark() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: AppColors.customBlack,
        titleTextStyle: boldSize16Text(),
      ),
      fontFamily: 'Pretendard',
      primaryColor: AppColors.customBlack,
      primaryColorDark: AppColors.customBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.customBlack,
        secondary: AppColors.customBlack,
        onPrimary: AppColors.customWhite,
        background: AppColors.customBlack,
        onBackground: AppColors.customWhite,
        surface: AppColors.customBlack,
        surfaceTint: AppColors.customBlack,
        onSurface: AppColors.customWhite,
      ),
      scaffoldBackgroundColor: AppColors.customBlack,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.customBlack,
          padding: const EdgeInsets.all(12),
          foregroundColor: AppColors.customBlack,
          disabledBackgroundColor: AppColors.customBlack.withOpacity(0.6),
          disabledForegroundColor: AppColors.customWhite.withOpacity(0.6),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
