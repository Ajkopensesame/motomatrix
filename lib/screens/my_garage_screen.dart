import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vin_data.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_vehicle_app_bar.dart';
import '../widgets/vin_summary_card.dart';
import '../widgets/question_card.dart';

class MyGarageScreen extends StatefulWidget {
  const MyGarageScreen({super.key});

  @override
  MyGarageScreenState createState() => MyGarageScreenState();
}

class MyGarageScreenState extends State<MyGarageScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid ?? 'anonymous';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mygarage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').doc(_userId).collection('vehicles').snapshots(),
            builder: (context, vehicleSnapshot) {
              if (vehicleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!vehicleSnapshot.hasData || vehicleSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No vehicles in your garage.'));
              }

              return ListView.builder(
                itemCount: vehicleSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final vehicleDoc = vehicleSnapshot.data!.docs[index];
                  final VinData vehicle = VinData.fromMap(vehicleDoc.data() as Map<String, dynamic>);

                  return Column(
                    children: [
                      VinSummaryCard(vinData: vehicle),
                      _buildRelatedQuestionsSection(vehicle),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        selectedVehicle: null,
        onVehicleSelected: (VinData vehicle) {
          // Implement your logic for when a vehicle is selected
        },
      ),
    );
  }

  Widget _buildRelatedQuestionsSection(VinData vehicle) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('forum_questions')
          .where('vehicleDetails.make', isEqualTo: vehicle.make)
          .where('vehicleDetails.model', isEqualTo: vehicle.model)
          .where('vehicleDetails.year', isEqualTo: vehicle.year.toString())
          .where('userId', isEqualTo: _userId) // Filter questions by the current user's ID
          .snapshots(),
      builder: (context, questionSnapshot) {
        if (questionSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (!questionSnapshot.hasData || questionSnapshot.data!.docs.isEmpty) {
          return const Text(
            'NO RELATED QUESTIONS FOUND',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: questionSnapshot.data!.docs.length,
          itemBuilder: (context, questionIndex) {
            final questionDoc = questionSnapshot.data!.docs[questionIndex];
            final questionData = questionDoc.data() as Map<String, dynamic>;

            // No need to fetch the user's name as the questions are already filtered by the current user
            return QuestionCard(
              make: vehicle.make,
              model: vehicle.model,
              year: vehicle.year.toString(),
              engineDisplacement: vehicle.engineDisplacement,
              dtcCode: questionData['dtcCode'] ?? 'N/A',
              questionText: questionData['question'],
              views: questionData['views'] ?? 0,
              questionRef: questionDoc.reference,
              userName: "Your Question", // Since it's filtered by the current user, you can set a static text
            );
          },
        );
      },
    );
  }

}
