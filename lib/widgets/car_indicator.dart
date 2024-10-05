import 'package:flutter/material.dart';

class CarIndicator extends StatefulWidget {
  final String affectedPart;
  final Color primaryColor;
  final Color accentColor;

  CarIndicator({
    required this.affectedPart,
    this.primaryColor = Colors.white,
    this.accentColor = Colors.red,
  });

  @override
  _CarIndicatorState createState() => _CarIndicatorState();
}

class _CarIndicatorState extends State<CarIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
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
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(width, height),
                    painter: ModernCarPainter(
                      affectedPart: widget.affectedPart,
                      animationValue: _animation.value,
                      primaryColor: widget.primaryColor,
                      accentColor: widget.accentColor,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['Body', 'Engine', 'Chassis', 'Network'].map((part) {
                return _buildLegendItem(part);
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(String part) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          color: part == widget.affectedPart ? widget.accentColor : widget.primaryColor,
        ),
        SizedBox(width: 5),
        Text(part, style: TextStyle(color: widget.primaryColor)),
      ],
    );
  }
}

class ModernCarPainter extends CustomPainter {
  final String affectedPart;
  final double animationValue;
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
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withOpacity(animationValue);

    // Draw car body
    if (affectedPart == 'Body') {
      paint.color = accentColor.withOpacity(animationValue);
    }
    canvas.drawRect(Rect.fromLTWH(50, 50, 200, 100), paint);

    // Draw car engine
    if (affectedPart == 'Engine') {
      paint.color = accentColor.withOpacity(animationValue);
    } else {
      paint.color = primaryColor.withOpacity(animationValue);
    }
    canvas.drawRect(Rect.fromLTWH(100, 60, 100, 40), paint);

    // Draw car chassis
    if (affectedPart == 'Chassis') {
      paint.color = accentColor.withOpacity(animationValue);
    } else {
      paint.color = primaryColor.withOpacity(animationValue);
    }
    canvas.drawRect(Rect.fromLTWH(50, 150, 200, 30), paint);

    // Draw car network (as an example)
    if (affectedPart == 'Network') {
      paint.color = accentColor.withOpacity(animationValue);
    } else {
      paint.color = primaryColor.withOpacity(animationValue);
    }
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
