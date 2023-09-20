import 'package:flutter/material.dart';
import '../themes/app_theme.dart';  // <-- Import the AppTheme

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  CustomElevatedButton({
    required this.label,
    this.onPressed,
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,  // <-- Set text color to white for better contrast
          fontSize: 18,  // <-- Increase font size to match CustomTextField
          fontWeight: FontWeight.w500,  // <-- Make text slightly bold to match CustomTextField
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.darkBlue),  // <-- Use the darkBlue color from AppTheme
        padding: MaterialStateProperty.all(padding ?? EdgeInsets.symmetric(vertical: 15.0, horizontal: 24.0)),
        elevation: MaterialStateProperty.all(elevation ?? 2.0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),  // <-- Add rounded corners
            side: BorderSide(color: AppColors.darkBlue, width: 2.0),  // <-- Add a border to match CustomTextField
          ),
        ),
      ),
    );
  }
}
