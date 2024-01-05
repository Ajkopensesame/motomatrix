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
        title: 'Mec Hero',
      ),
      body: CustomBackground(
        child: ListView(
          controller: _scrollController,
          children: [
            CustomScreenCard(
              title: 'Genesis',
              description: 'How Can I Help?',
              imagePath: 'assets/images/genesis.png',
              onTap: () => Navigator.pushNamed(context, '/chat_screen'),
            ),
            CustomScreenCard(
              title: 'My Garage',
              description: 'List Of Vehicles In My Garage',
              imagePath: 'assets/images/mygarage.png',
              onTap: () => Navigator.pushNamed(context, '/my_garage_screen'),
            ),
            CustomScreenCard(
              title: 'VIN Decoder',
              description: 'Decode vehicle information using VIN.',
              imagePath: 'assets/images/vin_decoder.png',
              onTap: () => Navigator.pushNamed(
                  context, '/vin_decoder'), // Use named route
            ),
            CustomScreenCard(
              title: 'Connect to OBD2',
              description: 'Connect and retrieve data from OBD2 devices.',
              imagePath: 'assets/images/obd2.png',
              onTap: () =>
                  Navigator.pushNamed(context, '/obd2'), // Use named route
            ),
            CustomScreenCard(
              title: 'DTC Information',
              description:
                  'Detailed information about Diagnostic Trouble Codes.',
              imagePath: 'assets/images/dtc_info.png',
              onTap: () =>
                  Navigator.pushNamed(context, '/dtc_info'), // Use named route
            ),
            CustomScreenCard(
              title: 'Common Fixes',
              description: 'View and explore common fixes for various DTCs.',
              imagePath: 'assets/images/common_fix.png',
              onTap: () => Navigator.pushNamed(
                  context, '/common_fix'), // Use named route
            ),
            CustomScreenCard(
              title: 'Request OEM Information',
              description: 'Request information directly from OEMs.',
              imagePath: 'assets/images/oem_request.png',
              onTap: () => Navigator.pushNamed(
                  context, '/oem_request'), // Use named route
            ),
            CustomScreenCard(
              title: 'User Profile',
              description: 'View and edit your profile details.',
              imagePath: 'assets/images/user_profile.png',
              onTap: () {
                // Debug statement
                Navigator.pushNamed(
                    context, '/user_profile'); // Use named route
              },
            ),
            CustomScreenCard(
              title: 'Settings',
              description: 'Manage app settings and preferences.',
              imagePath: 'assets/images/settings.png',
              onTap: () =>
                  Navigator.pushNamed(context, '/settings'), // Use named route
            ),
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
