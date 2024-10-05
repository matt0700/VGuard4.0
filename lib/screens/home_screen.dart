import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the entire column
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container for the logo with a blue circular background
            Container(
              width: 150, // Set the width of the circular background
              height: 150, // Set the height of the circular background
              decoration: BoxDecoration(
                color: Colors.blue, // Background color
                shape: BoxShape.circle, // Make it circular
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/vguard-logo.png', // Your logo asset
                  fit: BoxFit.cover, // Cover the circle
                ),
              ),
            ),
            SizedBox(height: 20), // Space between logo and text
            Text(
              'Home Screen',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
