import 'package:flutter/material.dart';
import '/services/mock_obd_service.dart'; // Import your mock service

class CarIndicator extends StatefulWidget {
  final String affectedPart;
  final Color primaryColor;
  final Color accentColor;
  final bool mockMode;

  CarIndicator({
    required this.affectedPart,
    this.primaryColor = Colors.white,
    this.accentColor = Colors.red,
    this.mockMode = false,
  });

  @override
  _CarIndicatorState createState() => _CarIndicatorState();
}

class _CarIndicatorState extends State<CarIndicator> with SingleTickerProviderStateMixin {
  late MockOBDService _mockService;
  String _currentAffectedPart = '';
  String _currentFaultCode = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _currentAffectedPart = widget.affectedPart;

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    if (widget.mockMode) {
      _mockService = MockOBDService();
      _mockService.startMockMode((affectedPart, faultCode) {
        setState(() {
          _currentAffectedPart = affectedPart; // Update the affected part
          _currentFaultCode = faultCode; // Update the fault code
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
        final aspectRatio = 300 / 200; // Adjust this based on your car design
        final width = constraints.maxWidth;
        final height = width / aspectRatio;

        return Column(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: CustomPaint(
                size: Size(width, height),
                painter: ModernCarPainter(
                  affectedPart: _currentAffectedPart,
                  animationValue: _animationController.value, // Pass animation value here
                  primaryColor: widget.primaryColor,
                  accentColor: widget.accentColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Affected Part: $_currentAffectedPart'),
            Text('Fault Code: $_currentFaultCode'),
          ],
        );
      },
    );
  }
}

class ModernCarPainter extends CustomPainter {
  final String affectedPart;
  final double animationValue; // Keep this for any animation you want to implement
  final Color primaryColor;
  final Color accentColor;

  ModernCarPainter({
    required this.affectedPart,
    required this.animationValue,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Car body dimensions
    const double bodyWidth = 200;
    const double bodyHeight = 100;
    const double roofHeight = 40;
    const double wheelRadius = 15;

    // Calculate positions
    double bodyX = (size.width - bodyWidth) / 2;
    double bodyY = size.height - bodyHeight - 20;

    // Draw car body
    paint.color = affectedPart == 'Body' ? accentColor : primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyX, bodyY, bodyWidth, bodyHeight),
        Radius.circular(10),
      ),
      paint,
    );

    // Draw roof
    paint.color = affectedPart == 'Network' ? accentColor : primaryColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyX + 20, bodyY - roofHeight, bodyWidth - 40, roofHeight),
        Radius.circular(10),
      ),
      paint,
    );

    // Draw windows
    paint.color = Colors.lightBlue.withOpacity(0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyX + 25, bodyY - roofHeight + 5, bodyWidth - 50, roofHeight - 10),
        Radius.circular(5),
      ),
      paint,
    );

    // Draw wheels
    paint.color = primaryColor;
    canvas.drawCircle(Offset(bodyX + 30, bodyY + bodyHeight), wheelRadius, paint);
    canvas.drawCircle(Offset(bodyX + 170, bodyY + bodyHeight), wheelRadius, paint);

    // Draw car lights
    paint.color = affectedPart == 'Engine' ? accentColor : Colors.yellow;
    canvas.drawCircle(Offset(bodyX + 10, bodyY + 20), 5, paint); // Left light
    canvas.drawCircle(Offset(bodyX + bodyWidth - 10, bodyY + 20), 5, paint); // Right light
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
