import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motomatrix/main.dart';
import 'package:motomatrix/services/firestore_service.dart';
import '../widgets/custom_background.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomBackground(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    final firebaseAuth = FirebaseAuth.instance;
    final firestoreService = FirestoreService();

    final user = firebaseAuth.currentUser;
    final lastSavedVehicle =
        user != null ? await firestoreService.getLastSavedVehicle() : null;

    if (!mounted) return;

    if (user != null && lastSavedVehicle != null) {
      ref.read(vehicleProvider.notifier).setSelectedVehicle(lastSavedVehicle);
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (user != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
