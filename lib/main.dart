import 'package:flutter/material.dart';
import 'package:motomatrix/providers/firebase_auth_service_provider.dart';
import 'package:motomatrix/providers/vehicle_provider.dart';
import 'package:motomatrix/screens/chat_screen.dart';
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

final vinDataProvider = StateNotifierProvider<VinDataNotifier, VinData?>(
    (ref) => VinDataNotifier());
final vehicleProvider = ChangeNotifierProvider((ref) => VehicleProvider());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      overrides: [],
      child: MotoMatrixApp(),
    ),
  );
}

class MotoMatrixApp extends ConsumerWidget {
  const MotoMatrixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MotoMatrix',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/common_fix': (context) => const CommonFixScreen(),
        '/dtc_info': (context) => const DTCInfoScreen(),
        '/obd2': (context) => const OBD2Screen(),
        '/oem_request': (context) => const OEMRequestScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/user_profile': (context) => const UserProfileScreen(),
        '/vin_decoder': (context) => const VINDecoderScreen(),
        '/connected_vehicle_screen': (context) =>
            const ConnectedVehicleScreen(),
        //'/genesis_main_screen': (context) => const GenesisMainScreen(),
        '/my_garage_screen': (context) => const MyGarageScreen(),
        '/chat_screen': (context) => const ChatScreen(),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    return null;
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<AppUser?>(
      stream: ref.read(firebaseAuthServiceProvider).userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        }
        return const CircularProgressIndicator();
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
