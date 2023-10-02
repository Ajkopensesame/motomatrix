import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../screens/chat_screen.dart';  // [ADDED] import the ChatScreen
import '../../screens/my_garage_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_textbutton.dart';
import '../../widgets/vehicle_display_widget.dart';

class GenesisMainScreen extends ConsumerStatefulWidget {
  @override
  _GenesisMainScreenState createState() => _GenesisMainScreenState();
}

class _GenesisMainScreenState extends ConsumerState<GenesisMainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'Select Vehicle'),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/genesis.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Consumer(builder: (context, watch, child) {
              final currentVinData = ref.watch(vinDataProvider);

              if (currentVinData != null) {
                return VehicleDisplayWidget(
                    make: currentVinData.make,
                    model: currentVinData.model,
                    year: currentVinData.year.toString());
              }

              return SizedBox.shrink();
            }),
            SizedBox(height: 20.0),
            CustomTextButton(
              label: "Select Vehicle",
              onPressed: _selectVehicle,
            ),
            SizedBox(height: 20.0),
            CustomTextButton(
              label: "Chat with Genesis",
              onPressed: _navigateToChat,  // [ADDED] Navigate to ChatScreen logic
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectVehicle() async {
    final selectedVehicle = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyGarageScreen()),
    );

    if (selectedVehicle != null) {
      ref.read(vinDataProvider.notifier).setVinData(selectedVehicle);
    }
  }

  // [ADDED] Logic to navigate to the chat screen with Genesis
  void _navigateToChat() {
    // Callback to fetch previous conversations
    void _fetchPreviousConversation() {
      print("Fetching previous conversations...");  // replace with real logic
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(fetchPreviousConversation: _fetchPreviousConversation,),
      ),
    );
  }
}
