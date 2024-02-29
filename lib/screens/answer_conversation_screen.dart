import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_app_bar.dart'; // Import intl package

class AnswerConversationScreen extends StatefulWidget {
  final String questionId;
  final String answerId;

  const AnswerConversationScreen({
    super.key,
    required this.questionId,
    required this.answerId,
  });

  @override
  AnswerConversationScreenState createState() => AnswerConversationScreenState();
}

class AnswerConversationScreenState extends State<AnswerConversationScreen> {
  final TextEditingController _commentController = TextEditingController();
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy HH:mm'); // Define date format

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a comment.')));
      return;
    }

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('forum_questions')
        .doc(widget.questionId)
        .collection('answers')
        .doc(widget.answerId)
        .collection('comments')
        .add({
      'commentText': _commentController.text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
  }

  String formatTimestamp(Timestamp timestamp) {
    return dateFormat.format(timestamp.toDate()); // Use the dateFormat to format the Firestore Timestamp
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Answer section with username and timestamp
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('forum_questions')
                        .doc(widget.questionId)
                        .collection('answers')
                        .doc(widget.answerId)
                        .get(),
                    builder: (context, answerSnapshot) {
                      if (!answerSnapshot.hasData) return const CircularProgressIndicator();
                      final answerData = answerSnapshot.data!.data() as Map<String, dynamic>;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(answerData['userId']).get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) return const CircularProgressIndicator();
                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                          final timestamp = answerData['timestamp'] as Timestamp; // Assuming your answer documents have a 'timestamp' field

                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text('${userData['name'] ?? 'Unknown User'} - ${formatTimestamp(timestamp)}'), // Display name and formatted timestamp
                                ),
                              ],
                            ),
                            subtitle: Text(answerData['answerText'] ?? 'No answer text'),
                          );
                        },
                      );
                    },
                  ),

                  // Comments section with username and timestamp
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forum_questions')
                        .doc(widget.questionId)
                        .collection('answers')
                        .doc(widget.answerId)
                        .collection('comments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot comment = snapshot.data!.docs[index];
                          final timestamp = comment['timestamp'] as Timestamp; // Assuming your comment documents have a 'timestamp' field

                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('users').doc(comment['userId']).get(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) return const LinearProgressIndicator();

                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text('${userSnapshot.data!['name'] ?? 'Unknown User'} - ${formatTimestamp(timestamp)}'), // Display name and formatted timestamp
                                    ),
                                  ],
                                ),
                                subtitle: Text(comment['commentText']),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Comment input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor), // Use your app color here
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor), // Use your app color for the enabled state
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0), // Use your app color for the focused state with a custom width if desired
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _submitComment,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 40), // Bottom padding
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
