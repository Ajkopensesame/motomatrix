import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';  // Make sure you import your AppUser model here

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Helper method to convert Firebase User to AppUser
  AppUser? _userFromFirebase(User? firebaseUser) {
    if (firebaseUser != null) {
      return AppUser(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',  // Assuming 'name' maps to Firebase's 'displayName'
        email: firebaseUser.email ?? '',       // Using Firebase's email
        // Add any other fields you have in AppUser
      );
    }
    return null;
  }

  // Stream to get user changes
  Stream<AppUser?> userChanges() {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  // Method to sign in with email and password
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

  // Method to sign up with email and password
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

  // Method to sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Method to get the current user
  AppUser? getCurrentUser() {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }
}
