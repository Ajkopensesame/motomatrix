import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../widgets/custom_background.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use a Timer instead of FutureBuilder since we always want to navigate to the login page
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/main');
    });

    return const Scaffold(
      body: CustomBackground(
        child: Center(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
