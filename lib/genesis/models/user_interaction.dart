import 'package:cloud_firestore/cloud_firestore.dart';

class UserInteraction {
  final String id;
  final String query;
  final Map<String, dynamic> vehicleDetailsFromVIN; // This can store decoded VIN details like make, model, year, etc.
  final Timestamp timestamp;
  final String userId; // This can be useful to link the interaction to a specific user, if necessary.

  UserInteraction({
    required this.id,
    required this.query,
    required this.vehicleDetailsFromVIN,
    required this.timestamp,
    required this.userId,
  });

  // Converts a Firestore document to a UserInteraction instance
  factory UserInteraction.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserInteraction(
      id: doc.id,
      query: data['query'] ?? '',
      vehicleDetailsFromVIN: data['vehicleDetailsFromVIN'] ?? {},
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userId: data['userId'] ?? '',
    );
  }

  // Converts a UserInteraction instance to a map
  Map<String, dynamic> toMap() {
    return {
      'query': query,
      'vehicleDetailsFromVIN': vehicleDetailsFromVIN,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}
