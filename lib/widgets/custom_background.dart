import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;

  CustomBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image container
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.7),
                BlendMode.dstATop,
              ),
            ),
          ),
        ),
        // Child widget
        child,
      ],
    );
  }
}
