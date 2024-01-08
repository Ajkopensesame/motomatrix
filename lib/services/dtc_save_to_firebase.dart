import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDataService {
  // Method to save vehicle and ChatGPT response
  Future<void> saveVehicleAndChatResponse(String make, String model,
      String year, String dtc, String chatGPTResponse) async {
    CollectionReference vehicleResponses =
        FirebaseFirestore.instance.collection('vehicle_responses');

    var querySnapshot = await vehicleResponses
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .where('dtc', isEqualTo: dtc)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // If the document doesn't exist, create a new one with searchCount 1
      await vehicleResponses.add({
        'make': make,
        'model': model,
        'year': year,
        'dtc': dtc,
        'chatGPTResponse': chatGPTResponse,
        'searchCount': 1, // New field for counting searches
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // If the document exists, increment the searchCount
      var doc = querySnapshot.docs.first;
      await vehicleResponses.doc(doc.id).update({
        'searchCount': FieldValue.increment(1),
      });
    }
  }

  // Method to check if a DTC response is already saved
  Future<bool> isDtcResponseAlreadySaved(
      String make, String model, String year, String dtc) async {
    CollectionReference vehicleResponses =
        FirebaseFirestore.instance.collection('vehicle_responses');

    QuerySnapshot querySnapshot = await vehicleResponses
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .where('dtc', isEqualTo: dtc)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Method to fetch a saved DTC response
  Future<String> fetchSavedDtcResponse(
      String make, String model, String year, String dtc) async {
    CollectionReference vehicleResponses =
        FirebaseFirestore.instance.collection('vehicle_responses');

    QuerySnapshot querySnapshot = await vehicleResponses
        .where('make', isEqualTo: make)
        .where('model', isEqualTo: model)
        .where('year', isEqualTo: year)
        .where('dtc', isEqualTo: dtc)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.get('chatGPTResponse');
    } else {
      return '';
    }
  }

  // Method to fetch the top 10 most recent DTC responses
  Future<List<Map<String, dynamic>>> fetchTopRecentDtcEntries() async {
    CollectionReference vehicleResponses =
        FirebaseFirestore.instance.collection('vehicle_responses');
    QuerySnapshot querySnapshot = await vehicleResponses
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
