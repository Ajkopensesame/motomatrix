// lib/widgets/custom_textfield.dart

import 'package:flutter/material.dart';
import '../themes/app_theme.dart';  // <-- Import the AppTheme

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? hintText;
  final int? maxLines;
  final String? label;

  CustomTextField({
    this.controller,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.hintText,
    this.maxLines,
    this.label,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(color: Colors.black), // This line sets the hintText color to black

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),  // <-- Rounded corners
          borderSide: BorderSide(
            color: AppColors.darkBlue,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),  // <-- Rounded corners
          borderSide: BorderSide(
            color: AppColors.darkBlue,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),  // <-- Rounded corners
          borderSide: BorderSide(
            color: AppColors.mustardYellow,
            width: 3.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),  // <-- Rounded corners
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),  // <-- Rounded corners
          borderSide: BorderSide(
            color: Colors.red,
            width: 3.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: AppColors.darkBlue,
      validator: validator,
      obscureText: obscureText!,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
