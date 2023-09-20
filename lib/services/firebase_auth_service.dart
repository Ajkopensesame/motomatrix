import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Helper method to convert Firebase User to AppUser
  AppUser? _userFromFirebase(User? firebaseUser) {
    if (firebaseUser != null) {
      return AppUser(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '', // Assuming 'name' maps to Firebase's 'displayName'
        email: firebaseUser.email ?? '',      // Using Firebase's email
        // ... any other fields you have in AppUser
      );
    }
    return null;
  }

  // Sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign up with email and password
  Future<AppUser?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the displayName with the provided name
      await userCredential.user?.updateDisplayName(name);

      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Get the current user
  AppUser? getCurrentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }
}
