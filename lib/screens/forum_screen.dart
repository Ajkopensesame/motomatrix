import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vin_data.dart';
import '../providers/firestore_service_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/question_card.dart';
import '../widgets/custom_vehicle_app_bar.dart'; // Make sure this import is correct

class ForumPage extends ConsumerStatefulWidget {
  final String? dtcCode;
  final String? make;
  final String? model;
  final String? year;
  final String? engineDisplacement;
  final String? vin;

  const ForumPage({
    super.key,
    this.dtcCode,
    this.make,
    this.model,
    this.year,
    this.engineDisplacement,
    this.vin,
  });

  @override
  ForumPageState createState() => ForumPageState();
}

class ForumPageState extends ConsumerState<ForumPage> {
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;
  String _userName = 'Anonymous';
  VinData? _selectedVehicle;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _initializeVehicleDetails();
  }

  Future<void> _fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists && userDoc.data()!.containsKey('name')) {
          setState(() {
            _userName = userDoc.data()!['name'];
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching user name: $e');
        }
      }
    }
  }

  void _initializeVehicleDetails() {
    if (widget.make != null &&
        widget.model != null &&
        widget.year != null &&
        widget.engineDisplacement != null &&
        widget.vin != null) {
      _selectedVehicle = VinData(
        make: widget.make,
        model: widget.model,
        year: widget.year,
        engineDisplacement: widget.engineDisplacement,
        id: widget.vin,
      );
    }
  }

  Future<void> _postQuestion() async {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your question.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestoreService = ref.read(firestoreServiceProvider);

    try {
      await firestoreService.saveForumQuestion(
        userId: userId,
        name: _userName,
        dtcCode: widget.dtcCode ?? '',
        make: _selectedVehicle?.make ?? '',
        model: _selectedVehicle?.model ?? '',
        year: _selectedVehicle?.year ?? '',
        engineDisplacement: _selectedVehicle?.engineDisplacement ?? '',
        vin: _selectedVehicle?.id ?? '',
        question: _questionController.text,
        mileage: '',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question posted successfully!')),
      );

      _questionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post question: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedVehicle == null)
              Text(
                'Please select your vehicle below to ask questions.',
                style: Theme.of(context).textTheme.titleLarge,
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Lets find a fix for your ${_selectedVehicle!.year} ${_selectedVehicle!.make} ${_selectedVehicle!.model} with a ${_selectedVehicle!.engineDisplacement}L',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            const Divider(),
            Text('Ask a Question', style: Theme.of(context).textTheme.titleLarge),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Type your question here...',
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
                  icon: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.send),
                  onPressed: _isLoading ? null : _postQuestion,
                ),
              ),
              maxLines: null,
            ),

            const SizedBox(height: 20),
            Text('Related Questions', style: Theme.of(context).textTheme.titleLarge),
            if (_selectedVehicle == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select a vehicle to view related questions.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              )
            else
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('forum_questions')
                    .where('vehicleDetails.make', isEqualTo: _selectedVehicle!.make)
                    .where('vehicleDetails.model', isEqualTo: _selectedVehicle!.model)
                    .where('vehicleDetails.year', isEqualTo: _selectedVehicle!.year)
                    .where('vehicleDetails.engineDisplacement', isEqualTo: _selectedVehicle!.engineDisplacement)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Text('Something went wrong');
                  if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return QuestionCard(
                          make: _selectedVehicle!.make,
                          model: _selectedVehicle!.model,
                          year: _selectedVehicle!.year,
                          engineDisplacement: _selectedVehicle!.engineDisplacement,
                          dtcCode: widget.dtcCode ?? '',
                          questionText: data['question'],
                          views: data['views'] ?? 0,
                          questionRef: document.reference,
                          userName: _userName,
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No related questions found. Be the first to ask a question!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {
          setState(() {
            _selectedVehicle = selectedVehicle;
          });
        },
      ),
    );
  }


  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
