import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motomatrix/screens/question_detail_screen.dart';

class QuestionCard extends StatelessWidget {
  final String? make;
  final String? model;
  final String? year;
  final String? engineDisplacement;
  final String? dtcCode;
  final String questionText;
  final int views;
  final DocumentReference questionRef;
  final String userName; // Add a parameter for the user's name

  const QuestionCard({
    super.key,
    this.make,
    this.model,
    this.year,
    this.engineDisplacement,
    this.dtcCode,
    required this.questionText,
    required this.views,
    required this.questionRef,
    required this.userName, // Make userName required
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Increment views optimistically
          questionRef.update({'views': FieldValue.increment(1)});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDetailsPage(
                questionId: questionRef.id,
                make: make ?? 'Unknown',
                model: model ?? 'Unknown',
                year: year ?? 'Unknown',
                engineDisplacement: engineDisplacement ?? 'Unknown',
                questionText: questionText,
                dtcCode: dtcCode ?? 'Unknown DTC',
                userName: userName, // Pass userName to the QuestionDetailsPage if necessary
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the user's name
              Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (make != null && model != null && year != null && engineDisplacement != null)
                Text('$year $make $model - ${engineDisplacement}L'),
              if (dtcCode != null)
                Text('DTC: $dtcCode'),
              Text(questionText),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: questionRef.collection('answers').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      int totalVotes = docs.fold(0, (total, doc) => total + (doc['votes'] as int? ?? 0));
                      int answersCount = docs.length;

                      return Row(
                        children: [
                          const Icon(Icons.thumb_up, size: 16.0),
                          Text(" Votes: $totalVotes"),
                          const SizedBox(width: 10),
                          const Icon(Icons.comment, size: 16.0),
                          Text(" Answers: $answersCount"),
                          const SizedBox(width: 10),
                          const Icon(Icons.visibility, size: 16.0),
                          Text(" Views: $views"),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          const Icon(Icons.visibility, size: 16.0),
                          Text(" Views: $views"),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
