import 'package:flutter/material.dart';
import '/services/mock_obd_service.dart'; // Import your mock service

class CarIndicator extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;
  final bool mockMode;

  CarIndicator({
    this.primaryColor = Colors.red, // Primary color is red
    this.accentColor = Colors.redAccent, // Accent color can be a lighter red
    this.mockMode = false,
  });

  @override
  _CarIndicatorState createState() => _CarIndicatorState();
}

class _CarIndicatorState extends State<CarIndicator>
    with SingleTickerProviderStateMixin {
  late MockOBDService _mockService;
  List<Map<String, String>> _currentFaultCodes = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.mockMode) {
      _mockService = MockOBDService();
      _mockService.startMockMode((faultCodes) {
        setState(() {
          _currentFaultCodes = faultCodes;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.mockMode) {
      _mockService.stopMockMode();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = 300 / 200;
        final width = constraints.maxWidth;
        final height = width / aspectRatio;

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Move the legend to the top
              _buildLegend(),
              SizedBox(height: 10),
              SizedBox(
                width: width,
                height: height,
                child: CustomPaint(
                  size: Size(width, height),
                  painter: ModernCarPainter(
                    affectedParts: _currentFaultCodes
                        .map((fc) => fc['affectedPart']!)
                        .toList(),
                    animationValue: _animationController.value,
                    primaryColor: widget.primaryColor,
                    accentColor: widget.accentColor,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _currentFaultCodes.length,
                  itemBuilder: (context, index) {
                    final faultCode = _currentFaultCodes[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Affected Part:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          faultCode['affectedPart']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Fault Code:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${faultCode['faultCode']} - ${faultCode['description']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Spread out legend items evenly
      children: [
        _buildLegendItem(Colors.blue, 'Body'),
        _buildLegendItem(Colors.orange, 'Engine'),
        _buildLegendItem(Colors.green, 'Chassis'),
        _buildLegendItem(Colors.purple, 'Network'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
class ModernCarPainter extends CustomPainter {
  final List<String> affectedParts;
  final double animationValue;
  final Color primaryColor;
  final Color accentColor;

  ModernCarPainter({
    required this.affectedParts,
    required this.animationValue,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final double width = size.width;
    final double height = size.height;
    final double bottomY = height * 0.8;

    // Draw car body
    paint.color = primaryColor; // Use primaryColor (e.g., red)

    // Define the width and height of the top square
    final topSquareWidth = width * 0.4; // Width of the top square (40% of the car width)
    final topSquareHeight = height * 0.15; // Height of the top square (15% of the total height)

    // Create the combined path for the car body and top square
    final bodyPath = Path()
      // Start with the top square (top-left corner of the square)
      ..moveTo((width - topSquareWidth) / 2, height * 0.45)
      // Top-right corner of the square
      ..lineTo((width + topSquareWidth) / 2, height * 0.45)
      // Bottom-right corner of the square
      ..lineTo((width + topSquareWidth) / 2, height * 0.6)
      // Move to the bottom-right corner of the car body
      ..lineTo(width * 0.9, height * 0.6)
      ..lineTo(width * 0.9, bottomY) // Bottom-right of the main body
      ..lineTo(width * 0.1, bottomY) // Bottom-left of the main body
      ..lineTo(width * 0.1, height * 0.6) // Top-left of the main body
      ..lineTo((width - topSquareWidth) / 2, height * 0.6) // Bottom-left of the top square
      ..close(); // Complete the path

    // Draw the combined car body with top square
    canvas.drawPath(bodyPath, paint);

    // Draw wheels
    paint.color = Colors.black;
    canvas.drawCircle(Offset(width * 0.25, bottomY), height * 0.1, paint);
    canvas.drawCircle(Offset(width * 0.75, bottomY), height * 0.1, paint);

    // Draw wheel rims
    paint.color = Colors.grey[400]!;
    canvas.drawCircle(Offset(width * 0.25, bottomY), height * 0.05, paint);
    canvas.drawCircle(Offset(width * 0.75, bottomY), height * 0.05, paint);
// Define colors for different parts
final bodyColor = Colors.blue.withOpacity(0.7 + 0.3 * animationValue);      // Blue for the body
final engineColor = Colors.orange.withOpacity(0.7);                         // Orange for the engine
final chassisColor = Colors.green.withOpacity(0.7);                         // Green for the chassis (wheels)
final networkColor = Colors.purple.withOpacity(0.7);                        // Purple for the network (top part)

// Highlight affected parts based on their type
if (affectedParts.contains('Body')) {
  // Highlight the bottom part of the car body
  paint.color = bodyColor;
  canvas.drawRect(
    Rect.fromLTWH(width * 0.1, height * 0.6, width * 0.8, bottomY - height * 0.6),
    paint,
  );
}

if (affectedParts.contains('Engine')) {
  // Highlight the front part of the car body (left side)
  paint.color = engineColor;
  canvas.drawRect(
    Rect.fromLTWH(width * 0.1, height * 0.6, width * 0.2, bottomY - height * 0.6),
    paint,
  );
}

if (affectedParts.contains('Chassis')) {
  // Highlight the wheels (chassis)
  paint.color = chassisColor;
  // Front wheel
  canvas.drawCircle(Offset(width * 0.25, bottomY), height * 0.12, paint);
  // Rear wheel
  canvas.drawCircle(Offset(width * 0.75, bottomY), height * 0.12, paint);
}

if (affectedParts.contains('Network')) {
  // Highlight the top part of the car body (roof and window area)
  paint.color = networkColor;
  canvas.drawRect(
    Rect.fromLTWH((width - topSquareWidth) / 2, height * 0.45, topSquareWidth, topSquareHeight),
    paint,
  );
}
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
