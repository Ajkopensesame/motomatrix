import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/main.dart';
import 'package:motomatrix/services/dtc_chat_gpt_service.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/services/dtc_save_to_firebase.dart';
import 'package:motomatrix/widgets/background_image_widget.dart';
import 'package:motomatrix/widgets/custom_app_bar.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';
import 'package:motomatrix/widgets/dtc_description_widget.dart';
import 'package:motomatrix/widgets/top_recent_dtc_list_widget.dart';

class AppColors {
  static const darkBlue = Color(0xFF193B52);
  static const mustardYellow = Color(0xFFC9A765);
}

class DTCInfoScreen extends ConsumerStatefulWidget {
  const DTCInfoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

    // Add listener to _searchController
    _searchController.addListener(() {
      final text = _searchController.text.toUpperCase();
      if (text != _searchController.text) {
        _searchController.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });
  }

  bool isValidDtcCode(String code) {
    RegExp regex = RegExp(r'^[PBUC][0-9]{4}$', caseSensitive: false);
    return regex.hasMatch(code);
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
      String dtcCode = _searchController.text;
      if (!isValidDtcCode(dtcCode)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid DTC code.')),
        );
        return;
      }

      bool isSaved = await VehicleDataService().isDtcResponseAlreadySaved(
        currentVinData.make ?? 'Unknown',
        currentVinData.model ?? 'Unknown',
        currentVinData.year ?? 'Unknown',
        dtcCode,
      );

      if (isSaved) {
        String savedResponse = await VehicleDataService().fetchSavedDtcResponse(
          currentVinData.make ?? 'Unknown',
          currentVinData.model ?? 'Unknown',
          currentVinData.year ?? 'Unknown',
          dtcCode,
        );

        setState(() {
          _dtcDescription = savedResponse;
          recentDtcEntries.clear();
        });
        return;
      }

      final chatCompletion =
          await _dtcChatGPTService.askDtcChatGPT(dtcCode, currentVinData);

      String chatGPTResponse = '';
      if (chatCompletion.choices.isNotEmpty &&
          chatCompletion.choices[0].message.content!.isNotEmpty) {
        var contentItem = chatCompletion.choices[0].message.content?.first;
        chatGPTResponse = contentItem?.text ?? '';
      }
      setState(() {
        _dtcDescription = chatGPTResponse;
        recentDtcEntries.clear();
      });

      await VehicleDataService().saveVehicleAndChatResponse(
        currentVinData.make ?? 'Unknown',
        currentVinData.model ?? 'Unknown',
        currentVinData.year ?? 'Unknown',
        dtcCode,
        chatGPTResponse,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
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
          const BackgroundImageWidget(),
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
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.mustardYellow))
                    : _dtcDescription.isNotEmpty
                        ? DtcDescriptionWidget(dtcDescription: _dtcDescription)
                        : TopRecentDtcListWidget(
                            recentDtcEntries: recentDtcEntries),
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

  @override
  void dispose() {
    _searchController.removeListener(() {});
    _searchController.dispose();
    super.dispose();
  }
}
