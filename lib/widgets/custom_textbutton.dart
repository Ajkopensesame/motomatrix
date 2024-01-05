import 'package:flutter/material.dart';
import '../themes/app_theme.dart';  // <-- Import the AppTheme

class CustomTextButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  const CustomTextButton({super.key, 
    required this.label,
    this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(  // <-- Added Padding for space
      padding: const EdgeInsets.only(top: 10.0),  // <-- Adjust as needed
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),  // <-- Adjust padding for better appearance
          side: const BorderSide(
            color: AppColors.darkBlue,  // <-- Use the darkBlue color from AppTheme for the border
            width: 2.0,  // <-- Increase border width to match CustomTextField
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),  // <-- Increased curve for rounded corners
          ),
          backgroundColor: Colors.white.withOpacity(0.5),  // <-- Use a slightly transparent white to match the field background
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.darkBlue,  // <-- Use the darkBlue color from AppTheme for text
            fontSize: 18,  // <-- Increase font size to match CustomTextField
            fontWeight: FontWeight.w500,  // <-- Make text slightly bold
          ),
        ),
      ),
    );
  }
}
