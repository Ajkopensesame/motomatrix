import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vin_data.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _userId;

  FirestoreService() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
    } else {
      _userId = 'anonymous'; // Fallback to 'anonymous' if no user is found
    }
  }

  CollectionReference get _userVehicles =>
      _firestore.collection('users').doc(_userId).collection('vehicles');

  Future<void> saveVinData(VinData vinData) async {
    DocumentReference docRef = await _userVehicles.add(vinData.toMap());
    vinData.documentId = docRef.id;
  }

  Future<void> deleteVinData(String vinId) async {
    await _userVehicles.doc(vinId).delete();
  }

  Future<List<VinData>> getSavedVINs() async {
    QuerySnapshot snapshot = await _userVehicles.get();
    return snapshot.docs.map((doc) {
      var vinData = VinData.fromMap(doc.data() as Map<String, dynamic>);
      vinData.documentId = doc.id;
      return vinData;
    }).toList();
  }

  Future<VinData?> getLastSavedVehicle() async {
    QuerySnapshot snapshot = await _userVehicles
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return VinData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  void updateUserProfile(String userId, String name, String email) {
    // Update user profile logic here
    // Example:
    // _firestore.collection('users').doc(userId).update({'name': name, 'email': email});
  }

  Future<void> saveForumQuestion({
    required String dtcCode,
    required String make,
    required String model,
    required String year,
    required String engineDisplacement,
    required String mileage,
    required String vin,
    required String question,
    required String userId,
    required String name,
  }) async {
    final forumQuestions = _firestore.collection('forum_questions');

    await forumQuestions.add({
      'userId': _userId,
      'name': name,
      'dtcCode': dtcCode,
      'vehicleDetails': {
        'make': make,
        'model': model,
        'year': year,
        'engineDisplacement': engineDisplacement,
        'mileage': mileage,
        'vin': vin,
      },
      'question': question,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
