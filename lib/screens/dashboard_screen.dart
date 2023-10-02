import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_background.dart';
import '../widgets/custom_screencard.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.position.pixels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Xenesis',),
      body: CustomBackground(
        child: ListView(
          controller: _scrollController,
          children: [
            CustomScreenCard(
              title: 'Genesis',
              description: 'How Can I Help?',
              imagePath: 'assets/images/genesis.png',
              onTap: () => Navigator .pushNamed(context, '/genesis_main_screen'),
            ),
            CustomScreenCard(
                title: 'My Garage',
                description: 'List Of Vehicles In My Garage',
                imagePath: 'assets/images/mygarage.png',
                onTap: () => Navigator .pushNamed(context, '/my_garage_screen'),
            ),


            CustomScreenCard(
              title: 'VIN Decoder',
              description: 'Decode vehicle information using VIN.',
              imagePath: 'assets/images/vin_decoder.png',
              onTap: () => Navigator.pushNamed(context, '/vin_decoder'), // Use named route
            ),
            CustomScreenCard(
              title: 'Connect to OBD2',
              description: 'Connect and retrieve data from OBD2 devices.',
              imagePath: 'assets/images/obd2.png',
              onTap: () => Navigator.pushNamed(context, '/obd2'), // Use named route
            ),
            CustomScreenCard(
              title: 'DTC Information',
              description: 'Detailed information about Diagnostic Trouble Codes.',
              imagePath: 'assets/images/dtc_info.png',
              onTap: () => Navigator.pushNamed(context, '/dtc_info'), // Use named route
            ),
            CustomScreenCard(
              title: 'Common Fixes',
              description: 'View and explore common fixes for various DTCs.',
              imagePath: 'assets/images/common_fix.png',
              onTap: () => Navigator.pushNamed(context, '/common_fix'), // Use named route
            ),
            CustomScreenCard(
              title: 'Request OEM Information',
              description: 'Request information directly from OEMs.',
              imagePath: 'assets/images/oem_request.png',
              onTap: () => Navigator.pushNamed(context, '/oem_request'), // Use named route
            ),

            CustomScreenCard(
              title: 'User Profile',
              description: 'View and edit your profile details.',
              imagePath: 'assets/images/user_profile.png',
              onTap: () {
                print('Tapped on User Profile Card'); // Debug statement
                Navigator.pushNamed(context, '/user_profile'); // Use named route
              },
            ),
            CustomScreenCard(
              title: 'Settings',
              description: 'Manage app settings and preferences.',
              imagePath: 'assets/images/settings.png',
              onTap: () => Navigator.pushNamed(context, '/settings'), // Use named route
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedScreenCard({required String title, required String description, required VoidCallback onTap, required int index}) {
    double offset = index * 150.0; // Adjust this value for desired spacing between cards
    double diff = _scrollPosition - offset;
    double opacity = diff < 0 ? 1 : (1 - diff / 200).clamp(0.0, 1.0); // Adjust '200' for desired fade-out distance

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, diff < 0 ? diff / 5 : 0), // Adjust '5' for desired parallax effect strength
        child: Card(
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(title),
            subtitle: Text(description),
            trailing: Icon(Icons.arrow_forward),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}