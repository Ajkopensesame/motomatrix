import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motomatrix/models/vin_data.dart';
import 'package:motomatrix/widgets/custom_vehicle_app_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_background.dart';
import '../widgets/custom_screencard.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(

      ),
      body: CustomBackground(
        child: ListView(
          controller: _scrollController,
          children: [
            CustomScreenCard(
              title: 'VIN Decoder',
              description: 'Decode Vehicle Information Using VIN.',
              imagePath: 'assets/images/vin_decoder.png',
              onTap: () => Navigator.pushNamed(
                  context, '/vin_decoder'), // Use named route
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.9), // Semi-transparent white background
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0), // Inner padding for the text
                  child: Text(
                    'Our app simplifies the process of obtaining vehicle information through our VIN Decoder. To use it, simply enter the Vehicle Identification Number (VIN) into the search bar and tap "Decode VIN." Instantly, you\'ll see the vehicle\'s year, make, and model displayed. For more in-depth details about the vehicle, you can tap on the decoded VIN, which will redirect you to a comprehensive information page. Additionally, a convenient swipe-left gesture on the VIN allows you to quickly remove it from your view. Plus, every decoded vehicle is automatically added to your personal garage in the app, making vehicle management seamless and efficient.',
                    style: TextStyle(
                        color: Colors.black87, // Set a darker color here
                        fontWeight: FontWeight.bold, // Set the text to bold
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            CustomScreenCard(
              title: 'Genesis',
              description: 'Chat With Me About Your Vehicle',
              imagePath: 'assets/images/genesis.png',
              onTap: () => Navigator.pushNamed(context, '/chat_screen'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.9), // Semi-transparent white background
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0), // Inner padding for the text
                  child: Text(
                    'Meet Genesis, your on-demand AI assistant for all things automotive within our app. Genesis is designed to provide you with detailed information and insights about your vehicle at the touch of a button. Whether you have a single car or a diverse collection in your garage, Genesis is equipped to assist.\n\nTo interact with Genesis, simply ask any question about your vehicle. If you\'re managing multiple vehicles within the app, the bottom app bar allows you to select the specific vehicle you\'re inquiring about. Once selected, Genesis will tailor its responses based on the chosen vehicle, ensuring personalized and relevant information. From maintenance tips to performance data, Genesis is here to enhance your understanding and connection with your car.',
                    style: TextStyle(
                        color: Colors.black87, // Set a darker color here
                        fontWeight: FontWeight.bold, // Set the text to bold
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            CustomScreenCard(
              title: 'My Garage',
              description: 'List Of Vehicles In My Garage',
              imagePath: 'assets/images/mygarage.png',
              onTap: () => Navigator.pushNamed(context, '/my_garage_screen'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.9), // Semi-transparent white background
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0), // Inner padding for the text
                  child: Text(
                    'In the "My Garage" section of our app, users can easily access and manage their collection of decoded Vehicle Identification Numbers (VINs). This feature acts as a central hub for all your vehicle information, providing a seamless way to review and interact with each vehicle\'s details.\n\nUpon selecting a specific VIN from your garage, the app will navigate you to a detailed overview of the vehicle. This page is designed to offer comprehensive insights, including but not limited to, the vehicle\'s specifications, history, and any other pertinent information derived from the VIN.\n\nFurthermore, if you have previously inquired about a Diagnostic Trouble Code (DTC) through our DTC Description page, this information will be conveniently displayed at the bottom of the vehicle\'s detailed description. This integration ensures that you have all the relevant diagnostic data and vehicle information in one place, enhancing your understanding and management of your vehicle\'s health and history.',
                    style: TextStyle(
                        color: Colors.black87, // Set a darker color here
                        fontWeight: FontWeight.bold, // Set the text to bold
                        fontSize: 18),
                  ),
                ),
              ),
            ),

            //CustomScreenCard(
            //title: 'Connect to OBD2',
            //description: 'Connect and retrieve data from OBD2 devices.',
            //imagePath: 'assets/images/obd2.png',
            //onTap: () =>
            //  Navigator.pushNamed(context, '/obd2'), // Use named route
            // ),
            CustomScreenCard(
              title: 'DTC Information',
              description:
                  'Detailed Information About DTC\'s.',
              imagePath: 'assets/images/dtc_info.png',
              onTap: () =>
                  Navigator.pushNamed(context, '/dtc_info'), // Use named route
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.9), // Semi-transparent white background
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0), // Inner padding for the text
                  child: Text(
                    'The DTC Info Page is your go-to resource for understanding the specifics behind the Diagnostic Trouble Codes (DTCs) of your vehicle. At the heart of this feature is a user-friendly search bar located at the top of the page, designed for direct input of any DTC you wish to investigate.\n\nUpon entering a DTC, the search function intelligently utilizes the vehicle currently selected in the bottom app bar to fetch and display a detailed explanation of the DTC provided by ChatGPT. This ensures that the information you receive is not only accurate but also relevant to your specific vehicle make and model.\n\nBelow the search functionality, the page showcases a dynamic list of the latest DTCs searched by users across the platform. This list includes each DTC\'s frequency of queries for the specific vehicle you have selected, offering insights into common issues encountered by others within the same vehicle community. This feature not only aids in diagnosing your own vehicle\'s issues but also fosters a sense of community by sharing collective experiences and solutions.',
                    style: TextStyle(
                        color: Colors.black87, // Set a darker color here
                        fontWeight: FontWeight.bold, // Set the text to bold
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            CustomScreenCard(
             title: 'Common Fixes',
             description: 'View and explore common fixes for various DTCs.',
            imagePath: 'assets/images/common_fix.png',
            onTap: () => Navigator.pushNamed(
               context, '/common_fix'), // Use named route
            ),
            //CustomScreenCard(
            //  title: 'Request OEM Information',
             //description: 'Request information directly from OEMs.',
             //imagePath: 'assets/images/oem_request.png',
            //onTap: () => Navigator.pushNamed(
            //  context, '/oem_request'), // Use named route
           // ),
            CustomScreenCard(
              title: 'User Profile',
              description: 'View and Edit Your Profile Details.',
              imagePath: 'assets/images/user_profile.png',
              onTap: () {
                // Debug statement
                Navigator.pushNamed(
                    context, '/user_profile'); // Use named route
              },
            ),

            //CustomScreenCard(
            //  title: 'Settings',
            //  description: 'Manage app settings and preferences.',
            //  imagePath: 'assets/images/settings.png',
            //  onTap: () =>
            //      Navigator.pushNamed(context, '/settings'), // Use named route
            // ),
          ],
        ),
      ),
      bottomNavigationBar: CustomVehicleAppBar(
        onVehicleSelected: (VinData selectedVehicle) {},
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
