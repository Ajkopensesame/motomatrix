import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDataService {
  // Method to save vehicle and ChatGPT response
  Future<void> saveVehicleAndChatResponse(String make, String model,
      String year, String dtc, String chatGPTResponse) async {
    CollectionReference vehicleResponses =
        FirebaseFirestore.instance.collection('vehicle_responses');

    await vehicleResponses.add({
      'make': make,
      'model': model,
      'year': year,
      'dtc': dtc,
      'chatGPTResponse': chatGPTResponse,
      'timestamp': FieldValue.serverTimestamp(),
    });
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
