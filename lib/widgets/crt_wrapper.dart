import 'package:flutter/material.dart';
import 'dart:math';

class CrtWrapper extends StatefulWidget {
  final Widget child;

  const CrtWrapper({super.key, required this.child});

  @override
  State<CrtWrapper> createState() => _CrtWrapperState();
}

class _CrtWrapperState extends State<CrtWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _flickerController;

  @override
  void initState() {
    super.initState();
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Scanlines
        IgnorePointer(
          child: CustomPaint(
            painter: _ScanlinePainter(),
            size: Size.infinite,
          ),
        ),
        // Vignette
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.5, 0.9, 1.0],
                center: Alignment.center,
                radius: 1.2,
              ),
            ),
          ),
        ),
        // Subtle Flicker
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _flickerController,
            builder: (context, child) {
              return Container(
                color: Colors.black.withOpacity(
                  0.01 + (Random().nextDouble() * 0.03),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.height; i += 3.0) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
