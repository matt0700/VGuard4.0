import 'package:flutter/material.dart';
import '/widgets/car_indicator.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String affectedPart = 'Engine'; // Set the default affected part
  List<String> faultCodes = ['P0300', 'P0420']; // Example fault codes

  // Method to update the affected part and fault codes (can be triggered by OBD logic later)
  void updateAffectedPart(String newPart) {
    setState(() {
      affectedPart = newPart;
      // Update the fault codes based on the affected part, if needed
      if (newPart == 'Engine') {
        faultCodes = ['P0300', 'P0301', 'P0302'];
      } else if (newPart == 'Body') {
        faultCodes = ['B0010', 'B0020'];
      } else {
        faultCodes = ['C0001', 'C0002']; // Example for Chassis
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Your Car'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Simulate updating the affected part (for now)
              updateAffectedPart('Body');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarIndicator(
              affectedPart: affectedPart, // This part will light up
              primaryColor: Colors.grey,
              accentColor: Colors.red,
            ),
            SizedBox(height: 20), // Space between car indicator and fault codes
            Container(
              width: 300, // Width of the fault codes box
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black12, // Background color of the box
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red, width: 2), // Border color
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fault Codes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Title color
                    ),
                  ),
                  SizedBox(height: 10),
                  ...faultCodes.map((code) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          code,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red, // Code color
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
