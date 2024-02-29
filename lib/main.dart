import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motomatrix/providers/vehicle_provider.dart';
import 'navigation/app_router.dart';
import 'themes/app_theme.dart';

final vehicleProvider = ChangeNotifierProvider((ref) => VehicleProvider());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MotoMatrixApp()));
}

class MotoMatrixApp extends ConsumerWidget {
  const MotoMatrixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final initialRoute = auth.currentUser != null ? '/common_fix' : '/login';

    return MaterialApp(
      title: 'MotoMatrix',
      theme: AppTheme.lightTheme,  // Ensure you have the AppTheme class defined in the themes/app_theme.dart
      initialRoute: initialRoute,
      routes: AppRouter.defineRoutes(),
    );
  }
}
