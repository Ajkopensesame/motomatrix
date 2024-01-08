import 'package:flutter/material.dart';

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
            title: Text(
              "${entry['year']} ${entry['make']} ${entry['model']} - ${entry['dtc']}",
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
