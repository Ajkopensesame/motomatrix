import 'package:flutter/material.dart';
import '../models/vin_data.dart';
import '../services/vin_decoder_service.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_elevatedbutton.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/vin_summary_card.dart';
import '../screens/vin_details_screen.dart';

class VINDecoderScreen extends StatefulWidget {
  @override
  _VINDecoderScreenState createState() => _VINDecoderScreenState();
}

class _VINDecoderScreenState extends State<VINDecoderScreen> {
  final VINDecoderService _vinDecoderService = VINDecoderService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _vinController = TextEditingController();
  final List<VinData> _vinDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchSavedVINs();
  }

  void _fetchSavedVINs() async {
    List savedVINs = await _firestoreService.getSavedVINs();
    setState(() {
      _vinDataList.clear();
      _vinDataList.addAll(savedVINs as Iterable<VinData>);
    });
  }

  void _decodeVIN(BuildContext context) async {
    try {
      final data = await _vinDecoderService.decodeVIN(_vinController.text);
      VinData vinData = VinData.fromMap(data);

      try {
        await _firestoreService.saveVinData(vinData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('VIN decoded and saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving decoded VIN: $e')),
        );
      }

      setState(() {
        _vinDataList.add(vinData);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error decoding VIN: $e')),
      );
    }
  }

  Future<void> _deleteVinData(VinData vinData) async {
    if (vinData.documentId != null)
    try {
      await _firestoreService.deleteVinData(vinData.documentId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VIN deleted successfully!')),
      );

      setState(() {
        _vinDataList.remove(vinData);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting VIN: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'VIN Decoder'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/vin_decoder.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _vinController,
                label: 'Enter VIN',
                hintText: 'Enter VIN',
              ),
              SizedBox(height: 20),
              Center(
                child: CustomElevatedButton(
                  label: 'Decode VIN',
                  onPressed: () => _decodeVIN(context),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _vinDataList.length,
                  itemBuilder: (context, index) {
                    final vinData = _vinDataList[index];
                    return Dismissible(
                      key: ValueKey(vinData.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Handle deletion synchronously
                        _deleteVinData(vinData);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VINDetailsScreen(vinData: vinData),
                            ),
                          );
                        },
                        child: VinSummaryCard(vinData: vinData),
                      ),
                    );
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
