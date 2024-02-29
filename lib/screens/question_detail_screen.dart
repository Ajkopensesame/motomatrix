import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import 'answer_conversation_screen.dart';

class QuestionDetailsPage extends StatefulWidget {
  final String questionId;
  final String make;
  final String model;
  final String year;
  final String engineDisplacement;
  final String questionText;
  final String dtcCode;
  final String userName;

  const QuestionDetailsPage({
    super.key,
    required this.questionId,
    required this.make,
    required this.model,
    required this.year,
    required this.engineDisplacement,
    required this.questionText,
    required this.dtcCode,
    required this.userName,
  });

  @override
  QuestionDetailsPageState createState() => QuestionDetailsPageState();
}

class QuestionDetailsPageState extends State<QuestionDetailsPage> {
  final TextEditingController _answerController = TextEditingController();

  Future<void> _submitAnswer() async {
    if (_answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an answer.')));
      return;
    }

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('forum_questions')
        .doc(widget.questionId)
        .collection('answers')
        .add({
      'answerText': _answerController.text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'votes': 0,
      'views': 0,
    });

    _answerController.clear();
  }

  Future<void> _updateVote(DocumentReference answerRef, int change) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot answerSnapshot = await transaction.get(answerRef);
      if (answerSnapshot.exists) {
        Map<String, dynamic> data = answerSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> userVotes = data['userVotes'] ?? {};
        int totalVotes = data['votes'] ?? 0;

        if (userVotes.containsKey(userId)) {
          int previousVote = userVotes[userId];
          if (previousVote == change) {
            return;
          }
          totalVotes -= previousVote;
        }

        userVotes[userId] = change;
        totalVotes += change;

        transaction.update(answerRef, {
          'votes': totalVotes,
          'userVotes': userVotes,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Align the column itself to the center
                children: [
                  Center( // Wrap the Text widget with Center
                    child: Text(
                      '${widget.year} ${widget.make} ${widget.model} ${widget.engineDisplacement}L',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center, // Ensure text alignment is also center
                    ),
                  ),
                  Text(
                    'DTC: ${widget.dtcCode}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center, // Ensure text alignment is also center
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.questionText,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('forum_questions')
                  .doc(widget.questionId)
                  .collection('answers')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Something went wrong'));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.data?.docs.isEmpty ?? true) return const Center(child: Text('No answers yet'));

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(data['userId']).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const ListTile(title: Text('Loading user data...'));
                        }

                        Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnswerConversationScreen(
                                  questionId: widget.questionId,
                                  answerId: document.id,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: userData['photoURL'] != null ? NetworkImage(userData['photoURL']) : null,
                                        child: userData['photoURL'] == null ? const Icon(Icons.person_outline) : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(userData['name'] ?? 'Anonymous')),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(data['answerText'] ?? 'No answer'),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.thumb_up),
                                        onPressed: () => _updateVote(document.reference, 1),
                                      ),
                                      Text('${data['votes'] ?? 0}'),
                                      IconButton(
                                        icon: const Icon(Icons.thumb_down),
                                        onPressed: () => _updateVote(document.reference, -1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  hintText: 'Write your answer here...',
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
                    onPressed: _submitAnswer,
                  ),
                ),
              ),
            ),
            Container(height: 50),
          ],
        ),
      ),

    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
