import 'package:cloud_firestore/cloud_firestore.dart';

class GenesisHistory {
  final String question;
  final String response;
  final DateTime timestamp;
  final bool isUser;

  GenesisHistory({
    required this.question,
    required this.response,
    required this.timestamp,
    required this.isUser,
  });

  // Converts the object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'response': response,
      'timestamp': timestamp,
      'isUser': isUser,
    };
  }

  // Constructs the object from a Map (from Firestore)
  factory GenesisHistory.fromMap(Map<String, dynamic> map) {
    return GenesisHistory(
      question: map['question'],
      response: map['response'],
      timestamp: map['timestamp'].toDate(),
      isUser: map['isUser'] ?? false,
    );
  }
}

class GenesisHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _historyCollection = 'genesis_history';

  // Save a new entry to the history
  Future<void> addEntry(GenesisHistory entry) async {
    await _firestore.collection(_historyCollection).add(entry.toMap());
  }

  // Retrieve the last 'n' entries from the history
  Future<List<GenesisHistory>> getLastNEntries(int n) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_historyCollection)
        .orderBy('timestamp', descending: true)
        .limit(n)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return GenesisHistory.fromMap(data);
    }).toList();
  }

  // Retrieve responses based on a question from history
  Future<List<GenesisHistory>> getResponsesForQuestion(String question) async {
    QuerySnapshot snapshot = await _firestore
        .collection(_historyCollection)
        .where('question', isEqualTo: question)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return GenesisHistory.fromMap(data);
    }).toList();
  }

  // Delete an entry from the history (based on ID)
  Future<void> deleteEntry(String id) async {
    await _firestore.collection(_historyCollection).doc(id).delete();
  }
}
