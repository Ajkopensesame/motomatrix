import 'package:flutter/material.dart';
import 'package:motomatrix/screens/forum_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/common_fix.dart';
import '../screens/connected_vehicle_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/dtc_info_screen.dart';
import '../screens/login_screen.dart';
import '../screens/my_garage_screen.dart';
import '../screens/obd2_screen.dart';
import '../screens/oem_request_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/vin_decoder_screen.dart';
// Import any other screens you need here

class AppRouter {
  static Map<String, WidgetBuilder> defineRoutes() {
    return {
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
      '/connected_vehicle_screen': (context) => const ConnectedVehicleScreen(),
      '/my_garage_screen': (context) => const MyGarageScreen(),
      '/chat_screen': (context) => const ChatScreen(),
      '/forum': (context) => const ForumPage(),
      // Add other routes as needed
    };
  }
}

