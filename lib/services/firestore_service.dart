import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vin_data.dart';

class FirestoreService {
  final CollectionReference _vinCollection = FirebaseFirestore.instance.collection('vins');

  Future<void> saveVinData(VinData vinData) async {
    print("Attempting to save VIN data...");  // Optional debug print
    try {
      await _vinCollection.add(vinData.toMap());
      print("VIN data saved successfully!");  // Optional debug print
    } catch (e) {
      print("Error saving VIN data: $e");  // Optional debug print
      throw e;  // Rethrow the exception to handle it elsewhere if needed
    }
  }

  Future<List<VinData>> getSavedVINs() async {
    QuerySnapshot snapshot = await _vinCollection.get();
    return snapshot.docs.map((doc) {
      VinData vinData = VinData.fromMap(doc.data() as Map<String, dynamic>);
      vinData.id = doc.id;  // Set the id property using the document ID
      return vinData;
    }).toList();
  }


  Future<void> deleteVinData(VinData vinData) async {
    print("Attempting to delete VIN data...");  // Optional debug print
    try {
      // Assuming VinData has an id property that corresponds to the Firestore document ID
      await _vinCollection.doc(vinData.id).delete();
      print("VIN data deleted successfully!");  // Optional debug print
    } catch (e) {
      print("Error deleting VIN data: $e");  // Optional debug print
      throw e;  // Rethrow the exception to handle it elsewhere if needed
    }
  }
}
