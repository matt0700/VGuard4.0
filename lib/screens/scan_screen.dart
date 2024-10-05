import 'package:flutter/material.dart';
import '/widgets/car_indicator.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CarIndicator(
          affectedPart: '', // Set the default affected part
          primaryColor: Colors.grey,
          accentColor: Colors.red,
          mockMode: true, // Enable mock mode
        ),
      ),
    );
  }
}
