import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tap the menu button (☰) for settings',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Version 1.0.0',
          style: TextStyle(fontSize: 10, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
