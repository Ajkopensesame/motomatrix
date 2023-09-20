import 'package:flutter/material.dart';

class AppColors {
  static const darkBlue = Color(0xFF193B52);
  static const mustardYellow = Color(0xFFC9A765);
// ... other colors
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.darkBlue,
    colorScheme: ThemeData().colorScheme.copyWith(
      secondary: AppColors.mustardYellow,
      onPrimary: Colors.white,  // Text color on primary color background
      onSecondary: Colors.white,  // Text color on secondary color background
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.darkBlue,  // Adjusts the cursor color
      selectionColor: AppColors.mustardYellow.withOpacity(0.5),  // Adjusts the text selection color
      selectionHandleColor: AppColors.mustardYellow,  // Adjusts the handle color
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.darkBlue,  // Background color of the context menu
      textStyle: TextStyle(color: Colors.white),  // Text color in the context menu
    ),
    // ... other theme properties
  );
}
