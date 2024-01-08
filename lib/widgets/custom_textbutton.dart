import 'package:flutter/material.dart';
import '../themes/app_theme.dart'; // Ensure AppTheme is correctly imported

class CustomTextButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  const CustomTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
          foregroundColor: MaterialStateProperty.all(AppColors.darkBlue),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return AppColors.darkBlue.withOpacity(0.2); // Splash color
              }
              return null;
            },
          ),
          side: MaterialStateProperty.all(
              const BorderSide(color: AppColors.darkBlue, width: 2.0)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
          padding: MaterialStateProperty.all(padding ??
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
