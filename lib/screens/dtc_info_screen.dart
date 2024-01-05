// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/main.dart';
import 'package:motomatrix/services/dtc_chat_gpt_service.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/services/dtc_save_to_firebase.dart';
import 'package:motomatrix/widgets/custom_app_bar.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';

class AppColors {
  static const darkBlue = Color(0xFF193B52);
  static const mustardYellow = Color(0xFFC9A765);
}

class DTCInfoScreen extends ConsumerStatefulWidget {
  const DTCInfoScreen({super.key});

  @override
  _DTCInfoScreenState createState() => _DTCInfoScreenState();
}

class _DTCInfoScreenState extends ConsumerState<DTCInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DtcChatGPTService _dtcChatGPTService = DtcChatGPTService();
  String _dtcDescription = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> recentDtcEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchTopRecentDtcEntries();
  }

  void _fetchTopRecentDtcEntries() async {
    recentDtcEntries = await VehicleDataService().fetchTopRecentDtcEntries();
    setState(() {});
  }

  void _onSearch() async {
    setState(() {
      _isLoading = true;
      _dtcDescription = '';
    });

    try {
      final currentVinData = ref.read(vehicleProvider).selectedVehicle;
      if (currentVinData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a vehicle first.')),
        );
        return;
      }

      bool isSaved = await VehicleDataService().isDtcResponseAlreadySaved(
        currentVinData.make ?? 'Unknown',
        currentVinData.model ?? 'Unknown',
        currentVinData.year ?? 'Unknown',
        _searchController.text,
      );

      if (isSaved) {
        String savedResponse = await VehicleDataService().fetchSavedDtcResponse(
          currentVinData.make ?? 'Unknown',
          currentVinData.model ?? 'Unknown',
          currentVinData.year ?? 'Unknown',
          _searchController.text,
        );

        setState(() {
          _dtcDescription = savedResponse;
          recentDtcEntries
              .clear(); // Clear recent entries on displaying saved response
        });
        return;
      }

      final chatCompletion = await _dtcChatGPTService.askDtcChatGPT(
          _searchController.text, currentVinData);

      String chatGPTResponse = '';
      if (chatCompletion.choices.isNotEmpty &&
          chatCompletion.choices[0].message.content!.isNotEmpty) {
        var contentItem = chatCompletion.choices[0].message.content?.first;
        // Assuming contentItem has a property 'text' which is a String
        chatGPTResponse = contentItem?.text ?? '';
      }
      setState(() {
        _dtcDescription = chatGPTResponse;
        recentDtcEntries.clear(); // Clear recent entries on new search
      });

      await VehicleDataService().saveVehicleAndChatResponse(
        currentVinData.make ?? 'Unknown',
        currentVinData.model ?? 'Unknown',
        currentVinData.year ?? 'Unknown',
        _searchController.text,
        chatGPTResponse,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'DTC Information'),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) => _onSearch(),
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter DTC',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: _onSearch,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.darkBlue,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: AppColors.mustardYellow,
                        width: 2.0,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors
                              .mustardYellow, // Custom color for the indicator
                        ),
                      )
                    : _dtcDescription.isNotEmpty
                        ? _buildDtcDescription()
                        : _buildTopRecentDtcList(),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {},
      ),
    );
  }

  Widget _buildTopRecentDtcList() {
    return ListView.builder(
      itemCount: recentDtcEntries.length,
      itemBuilder: (context, index) {
        var entry = recentDtcEntries[index];
        return Card(
          // Wrap with Card for better UI
          margin: const EdgeInsets.all(10.0),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
                horizontal: 10.0), // Padding for the title area
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
                  width: double
                      .infinity, // Ensures the container takes up full width
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

  Widget _buildDtcDescription() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _dtcDescription,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/images/dtc_info.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
