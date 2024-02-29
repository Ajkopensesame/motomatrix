import 'package:flutter/material.dart';
import '../themes/app_theme.dart'; // Ensure this path is correct for your AppTheme or AppColors

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
  final Color? borderColor; // Add borderColor parameter
  final String? label; // Add label parameter, if you decide to use it
  final Widget? suffixIcon; // Add suffixIcon parameter

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.hintText,
    this.maxLines,
    this.borderColor, // Initialize borderColor
    this.label, // Initialize label
    this.suffixIcon, // Initialize suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText ?? label, // Use labelText or label
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: const TextStyle(color: Colors.black),
        suffixIcon: suffixIcon, // Use suffixIcon
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.darkBlue, // Use borderColor with fallback
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.darkBlue, // Use borderColor with fallback
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.mustardYellow, // Use borderColor with fallback
            width: 3.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 3.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: borderColor ?? AppColors.darkBlue, // Use borderColor with fallback
      validator: validator,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
