import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  static const Color darkBlue = Color(0xFF193B52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: darkBlue,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Symbols.home, color: Colors.white, size: 30),
            onPressed: () {Navigator.of(context).pushNamed('/common_fix');},
          ),
          IconButton(
            icon: const Icon(Symbols.barcode_scanner, color: Colors.white, size: 30),
            onPressed: () {Navigator.of(context).pushReplacementNamed('/vin_decoder');},
          ),

          IconButton(
            icon: const Icon(Symbols.chat, color: Colors.white, size: 30),
            onPressed: () {Navigator.of(context).pushNamed('/chat_screen');},
          ),
          IconButton(
            icon: const Icon(Symbols.crisis_alert, color: Colors.white, size: 30),
            onPressed: () {Navigator.of(context).pushNamed('/dtc_info');},
          ),
          IconButton(
            icon: const Icon(Symbols.directions_car, color: Colors.white, size: 30),
            onPressed: () {Navigator.of(context).pushNamed('/my_garage_screen');},
          ),
          IconButton(
            icon: const Icon(Symbols.help, color: Colors.white, size: 30),
            onPressed: () {Navigator.of(context).pushNamed('/dashboard');},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
