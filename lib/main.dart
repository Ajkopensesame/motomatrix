import 'package:flutter/material.dart';
import 'package:motomatrix/providers/firebase_auth_service_provider.dart';
import 'package:motomatrix/screens/common_fix.dart';
import 'package:motomatrix/screens/connected_vehicle_screen.dart';
import 'package:motomatrix/screens/dtc_info_screen.dart';
import 'package:motomatrix/screens/my_garage_screen.dart';
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
import 'genesis/screens/genesis_main_screen.dart';
import 'models/app_user.dart';
import 'models/vin_data.dart';
import 'services/firebase_auth_service.dart';
import 'screens/login_screen.dart';

class StringUtil {
  static String toTitleCase(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.toLowerCase().split(' ').map((word) {
      final String firstLetter = word.isNotEmpty ? word[0].toUpperCase() : '';
      final String remaining = word.length > 1 ? word.substring(1) : '';
      return '$firstLetter$remaining';
    }).join(' ');
  }
}

class VinDataNotifier extends StateNotifier<VinData?> {
  VinDataNotifier() : super(null);

  void setVinData(VinData vinData) {
    state = vinData;
  }
}

final vinDataProvider = StateNotifierProvider<VinDataNotifier, VinData?>((ref) => VinDataNotifier());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MotoMatrixApp(),
      overrides: [],
    ),
  );
}

class MotoMatrixApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MotoMatrix',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/common_fix': (context) => CommonFixScreen(),
        '/dtc_info': (context) => DTCInfoScreen(),
        '/obd2': (context) => OBD2Screen(),
        '/oem_request': (context) => OEMRequestScreen(),
        '/settings': (context) => SettingsScreen(),
        '/signup': (context) => SignUpScreen(),
        '/user_profile': (context) => UserProfileScreen(),
        '/vin_decoder': (context) => VINDecoderScreen(),
        '/connected_vehicle_screen': (context) => ConnectedVehicleScreen(),
        '/genesis_main_screen' : (context) => GenesisMainScreen(),
        '/my_garage_screen' : (context) => MyGarageScreen()
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    return null;
  }
}

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<AppUser?>(
      stream: ref.read(firebaseAuthServiceProvider).userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return DashboardScreen();
          } else {
            return LoginScreen();
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final auth = ref.read(firebaseAuthProvider);
  return auth.getCurrentUser();
});

final firebaseAuthProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
