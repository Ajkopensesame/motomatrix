import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/question_card.dart';



class CommonFixScreen extends ConsumerStatefulWidget {
  const CommonFixScreen({super.key});



  @override
  ConsumerState<CommonFixScreen> createState() => _CommonFixScreenState();
}

class _CommonFixScreenState extends ConsumerState<CommonFixScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const Color mustardYellow = Color(0xFFC9A765);
  static const darkBlue = Color(0xFF193B52);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/common_fix.png'), // Path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: const Icon(Icons.search, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => setState(() {}),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('forum_questions')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Text('Something went wrong');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(mustardYellow),
                    ),
                  );
                  }

                  final searchTerms = _searchController.text.toLowerCase().split(' ');
                  final filteredDocs = snapshot.data?.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final questionText = data['question'].toString().toLowerCase();
                    final dtcCode = data['dtcCode'].toString().toLowerCase();
                    final vehicleDetails = data['vehicleDetails'] as Map<String, dynamic>?;
                    final vehicleSearchString = '${vehicleDetails?['make']} ${vehicleDetails?['model']} ${vehicleDetails?['year']} ${vehicleDetails?['engineDisplacement']}'.toLowerCase();
                    final fullSearchString = '$questionText $dtcCode $vehicleSearchString';

                    // Check if all search terms are present in the combined searchable string
                    return searchTerms.every((term) => fullSearchString.contains(term));
                  }).toList() ?? [];

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final questionDoc = filteredDocs[index];
                      final data = questionDoc.data() as Map<String, dynamic>;
                      final vehicleDetails = data['vehicleDetails'] as Map<String, dynamic>?;
                      final userId = data['userId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) return const SizedBox.shrink();

                          final userName = userSnapshot.data!['name'] ?? 'Anonymous';

                          return QuestionCard(
                            make: vehicleDetails?['make'],
                            model: vehicleDetails?['model'],
                            year: vehicleDetails?['year'].toString(),
                            engineDisplacement: vehicleDetails?['engineDisplacement'],
                            dtcCode: data['dtcCode'] ?? 'Unknown DTC',
                            questionText: data['question'],
                            views: data['views'] ?? 0,
                            questionRef: questionDoc.reference,
                            userName: userName,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/forum');
        },
        backgroundColor: darkBlue, // Using the mustardYellow color for the FAB
        child: const Icon(Symbols.forum, color: Colors.white, size: 40), // Icon inside the FAB, change it as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Positioning the FAB at the bottom center
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
