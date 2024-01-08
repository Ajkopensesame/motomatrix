import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VehicleDataService {
  final CollectionReference vehicleResponses =
      FirebaseFirestore.instance.collection('vehicle_responses');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  get make => null;

  get model => null;

  get year => null;

  Future<List<Map<String, dynamic>>> fetchUserSearchedDtcEntries(
      String? make, String? model, String? year) async {
    // Get current user's ID
    String userId = _auth.currentUser?.uid ?? '';

    // Query for DTCs searched by this user
    QuerySnapshot querySnapshot = await vehicleResponses
        .where('userId', isEqualTo: userId)
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    // Convert the query results to a list of maps
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<bool> isDtcResponseAlreadySaved(String make, String model, String year,
      String dtc, String engineDisplacement) async {
    var querySnapshot = await vehicleResponses
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .where('dtc', isEqualTo: dtc)
        .where('engineDisplacement', isEqualTo: engineDisplacement)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> fetchSavedDtcResponse(String make, String model, String year,
      String dtc, String engineDisplacement) async {
    var querySnapshot = await vehicleResponses
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .where('dtc', isEqualTo: dtc)
        .where('engineDisplacement', isEqualTo: engineDisplacement)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.get('chatGPTResponse');
    } else {
      return '';
    }
  }

  Future<void> incrementAndSaveResponse(
      String make,
      String model,
      String year,
      String dtc,
      String engineDisplacement,
      String chatGPTResponse,
      bool isSaved) async {
    String userId = _auth.currentUser?.uid ?? 'anonymous';
    if (isSaved) {
      var querySnapshot = await vehicleResponses
          .where('make', isEqualTo: make)
          .where('model', isEqualTo: model)
          .where('year', isEqualTo: year)
          .where('dtc', isEqualTo: dtc)
          .where('engineDisplacement', isEqualTo: engineDisplacement)
          .limit(1)
          .get();
      var doc = querySnapshot.docs.first;
      await vehicleResponses.doc(doc.id).update({
        'searchCount': FieldValue.increment(1),
      });
    } else {
      await vehicleResponses.add({
        'make': make,
        'model': model,
        'year': year,
        'dtc': dtc,
        'engineDisplacement': engineDisplacement,
        'chatGPTResponse': chatGPTResponse,
        'searchCount': 1,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchTopRecentDtcEntries() async {
    QuerySnapshot querySnapshot = await vehicleResponses
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs.map((doc) {
      // Convert the entire document into a Map and explicitly type cast it.
      var data = doc.data() as Map<String, dynamic>;
      // Return the document data with an explicit search count.
      // If the searchCount field does not exist, it defaults to 0.
      return {
        'make': data['make'] ?? 'Unknown',
        'model': data['model'] ?? 'Unknown',
        'year': data['year'] ?? 'Unknown',
        'dtc': data['dtc'] ?? 'Unknown',
        'engineDisplacement': data['engineDisplacement'] ?? 'Unknown',
        'searchCount': data['searchCount'] ?? 0,
        'chatGPTResponse': data['chatGPTResponse'] ?? '',
        // Include any other fields you want from the document.
      };
    }).toList();
  }

  Future<int> fetchSearchCount(String make, String model, String year,
      String dtc, String engineDisplacement) async {
    var querySnapshot = await vehicleResponses
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .where('dtc', isEqualTo: dtc)
        .where('engineDisplacement', isEqualTo: engineDisplacement)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      if (data is Map<String, dynamic>) {
        return data['searchCount'] ?? 0;
      }
    }
    return 0;
  }
}
