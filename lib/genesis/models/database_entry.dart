import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseEntry {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new entry to the database
  Future<void> addEntry(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print("Error adding entry: $e");
      // Handle error accordingly
    }
  }

  // Update an existing entry in the database
  Future<void> updateEntry(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      print("Error updating entry: $e");
      // Handle error accordingly
    }
  }

  // Retrieve a specific entry from the database
  Future<DocumentSnapshot?> getEntry(String collection, String documentId) async {
    try {
      return await _firestore.collection(collection).doc(documentId).get();
    } catch (e) {
      print("Error fetching entry: $e");
      // Handle error accordingly
      return null;
    }
  }

// In the future, you might want to add methods to:
// 1. Delete entries
// 2. Query multiple entries based on certain conditions
// 3. Listen to real-time changes in the database
}

