import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import 'firebase_auth_service_provider.dart';

final userProvider = StreamProvider<AppUser?>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return authService.userChanges();
});
