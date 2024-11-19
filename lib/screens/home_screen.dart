import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              decoration: const BoxDecoration(
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
            const SizedBox(height: 20), // Space between logo and text
            const Text(
              'Home Screen',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
