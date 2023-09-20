import 'package:cloud_firestore/cloud_firestore.dart';

class LearningModel {
  final String id;
  final String initialQuery; // Original question asked by the user
  final Map<String, dynamic> vehicleDetailsFromVIN; // Details about the vehicle involved in the query
  final String responseGenerated; // Genesis's initial response to the query
  final String userFeedback; // Feedback from user about the accuracy/relevance of the response
  final List<String> relatedQueries; // Other queries that may be related to the initial question
  final Timestamp timestamp;
  final String userId; // Linking the learning instance to a specific user

  LearningModel({
    required this.id,
    required this.initialQuery,
    required this.vehicleDetailsFromVIN,
    required this.responseGenerated,
    required this.userFeedback,
    this.relatedQueries = const [],
    required this.timestamp,
    required this.userId,
  });

  // Converts a Firestore document to a LearningModel instance
  factory LearningModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LearningModel(
      id: doc.id,
      initialQuery: data['initialQuery'] ?? '',
      vehicleDetailsFromVIN: data['vehicleDetailsFromVIN'] ?? {},
      responseGenerated: data['responseGenerated'] ?? '',
      userFeedback: data['userFeedback'] ?? '',
      relatedQueries: List<String>.from(data['relatedQueries'] ?? []),
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userId: data['userId'] ?? '',
    );
  }

  // Converts a LearningModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'initialQuery': initialQuery,
      'vehicleDetailsFromVIN': vehicleDetailsFromVIN,
      'responseGenerated': responseGenerated,
      'userFeedback': userFeedback,
      'relatedQueries': relatedQueries,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}

