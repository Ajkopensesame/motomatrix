import 'package:flutter/material.dart';
import 'join_discussion_button.dart';  // Ensure this import path is correct

class TopRecentDtcListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentDtcEntries;

  const TopRecentDtcListWidget({super.key, required this.recentDtcEntries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recentDtcEntries.length,
      itemBuilder: (context, index) {
        var entry = recentDtcEntries[index];

        return Card(
          margin: const EdgeInsets.all(10.0),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${entry['year']} ${entry['make']} ${entry['model']} - ${entry['dtc']}",
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "This DTC searched ${entry['searchCount']} ${entry['searchCount'] == 1 ? 'time' : 'times'}!",
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          entry['chatGPTResponse'],
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    JoinDiscussionButton(
                      dtcCode: entry['dtc'],
                      make: entry['make'] ?? 'Unknown',  // Provide a fallback value
                      model: entry['model'] ?? 'Unknown',  // Provide a fallback value
                      year: entry['year']?.toString() ?? 'Unknown',  // Ensure year is a string and provide a fallback
                      engineDisplacement: entry['engineDisplacement'] ?? 'Unknown',  // Provide a fallback value
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
