import 'package:flutter/material.dart';
import 'package:motomatrix/screens/common_fix.dart';
import 'package:motomatrix/screens/connected_vehicle_screen.dart';
import 'package:motomatrix/screens/dtc_info_screen.dart';
import 'package:motomatrix/screens/obd2_screen.dart';
import 'package:motomatrix/screens/oem_request_screen.dart';
import 'package:motomatrix/screens/settings_screen.dart';
import 'package:motomatrix/screens/signup_screen.dart';
import 'package:motomatrix/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/screens/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motomatrix/screens/user_profile_screen.dart';
import 'package:motomatrix/screens/vin_decoder_screen.dart';
import 'package:motomatrix/themes/app_theme.dart';
import 'models/app_user.dart';
import 'services/firebase_auth_service.dart';
import 'genesis/services/machine_learning_service.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final MachineLearningService mlService = MachineLearningService('assets/lite-model_qat_mobilebert_xs_qat_lite_1.tflite');

  runApp(
    ProviderScope(
      child: MotoMatrixApp(),
      // This is where you can provide the mlService to the rest of your app if needed
       overrides: [
         machineLearningServiceProvider.overrideWithValue(mlService),
       ],
    ),
  );
}

class MotoMatrixApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MotoMatrix',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/common_fix': (context) => CommonFixScreen(), // Replace with your CommonFixScreen widget
        '/dtc_info': (context) => DTCInfoScreen(),
        '/obd2': (context) => OBD2Screen(),
        '/oem_request': (context) => OEMRequestScreen(),
       // '/region_selection': (context) => RegionSelectionScreen(),
        '/settings': (context) => SettingsScreen(),
        '/signup': (context) => SignUpScreen(),
        '/user_profile': (context) => UserProfileScreen(),
        '/vin_decoder': (context) => VINDecoderScreen(),
        '/connected_vehicle_screen': (context) => ConnectedVehicleScreen(),
        // Add other routes as needed
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    return null;
  }
}

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final auth = ref.read(firebaseAuthProvider);
  return auth.getCurrentUser();
});

final firebaseAuthProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

// Uncomment if you want to make mlService available to the rest of your app
final machineLearningServiceProvider = Provider<MachineLearningService>((ref) => throw UnimplementedError());

