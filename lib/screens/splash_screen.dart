import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../widgets/custom_background.dart';

class SplashScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use a Timer instead of FutureBuilder since we always want to navigate to the login page
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
