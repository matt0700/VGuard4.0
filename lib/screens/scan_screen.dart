import 'package:flutter/material.dart';
import '/widgets/car_indicator.dart';


class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarIndicator(
              primaryColor: Colors.black,
              accentColor: Colors.red,
              mockMode: true, 
            ),
          ),
        ],
      ),
    );
  }
}