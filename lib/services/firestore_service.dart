import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vin_data.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String _userId;  // Declare _userId as a late final variable

  FirestoreService() {
    // Initialize _userId with the current authenticated user's ID
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
  }

  CollectionReference get _userVehicles => _firestore.collection('users').doc(_userId).collection('vehicles');
  CollectionReference get _problemsAndFixes => _firestore.collection('problems_and_fixes');

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
      vinData.documentId = doc.id;  // Populate documentId here
      return vinData;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getPotentialFixes(String problemDescription) async {
    QuerySnapshot snapshot = await _problemsAndFixes.where('problemDescription', isEqualTo: problemDescription).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> addOrUpdateProblem(String problemDescription, List<String> associatedVINs, List<Map<String, dynamic>> proposedFixes, List<String> tags) async {
    final problemDoc = await _problemsAndFixes.where('problemDescription', isEqualTo: problemDescription).get();

    if (problemDoc.docs.isEmpty) {
      await _problemsAndFixes.add({
        'problemDescription': problemDescription,
        'associatedVINs': associatedVINs,
        'proposedFixes': proposedFixes,
        'tags': tags,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    } else {
      await _problemsAndFixes.doc(problemDoc.docs.first.id).update({
        'associatedVINs': FieldValue.arrayUnion(associatedVINs),
        'proposedFixes': FieldValue.arrayUnion(proposedFixes),
        'tags': FieldValue.arrayUnion(tags),
        'updatedAt': Timestamp.now(),
      });
    }
  }

  Future<void> deleteProblem(String problemId) async {
    await _problemsAndFixes.doc(problemId).delete();
  }

  Future<void> voteForFix(String problemId, String fixDescription) async {
    DocumentSnapshot problemDoc = await _problemsAndFixes.doc(problemId).get();
    Map<String, dynamic>? problemData = problemDoc.data() as Map<String, dynamic>?;
    if (problemData != null && problemData['proposedFixes'] != null) {
      List<Map<String, dynamic>> fixes = List.from(problemData['proposedFixes']);
      for (var fix in fixes) {
        if (fix['description'] == fixDescription) {
          fix['votes'] = (fix['votes'] ?? 0) + 1;
          break;
        }
      }
      await _problemsAndFixes.doc(problemId).update({'proposedFixes': fixes});
    }
  }

  Future<void> addCommentToProblem(String problemId, String commentText) async {
    await _problemsAndFixes.doc(problemId).collection('comments').add({
      'userId': _userId,
      'commentText': commentText,
      'createdAt': Timestamp.now(),
    });
  }

  Future<List<Map<String, dynamic>>> getCommentsForProblem(String problemId) async {
    QuerySnapshot snapshot = await _problemsAndFixes.doc(problemId).collection('comments').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> addTagToProblem(String problemId, String tag) async {
    await _problemsAndFixes.doc(problemId).update({
      'tags': FieldValue.arrayUnion([tag])
    });
  }
}
