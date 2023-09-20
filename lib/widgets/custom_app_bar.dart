import 'package:flutter/material.dart';
import '../themes/app_theme.dart';  // <-- Import the AppTheme

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;

  CustomAppBar({
    required this.title,
    this.actions,
    this.centerTitle,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,  // <-- Use the darkBlue color from AppTheme for the title
          fontSize: 20,  // <-- Increase font size for the title
          fontWeight: FontWeight.w500,  // <-- Make title text slightly bold
        ),
      ),
      actions: actions,
      centerTitle: centerTitle ?? true,
      bottom: bottom,
      backgroundColor: AppColors.darkBlue,  // <-- Use the mustardYellow color from AppTheme for the background
      elevation: 4.0,  // <-- Add some elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10.0),  // <-- Add a slight curve to the bottom of the AppBar
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
