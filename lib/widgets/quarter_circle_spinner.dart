import 'dart:math' as math;
import 'package:flutter/material.dart';

class QuarterCircleSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const QuarterCircleSpinner({
    super.key,
    this.size = 60.0,
    this.color = Colors.white,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<QuarterCircleSpinner> createState() => _QuarterCircleSpinnerState();
}

class _QuarterCircleSpinnerState extends State<QuarterCircleSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: QuarterCirclePainter(color: widget.color),
          ),
        );
      },
    );
  }
}

class QuarterCirclePainter extends CustomPainter {
  final Color color;

  QuarterCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(
      rect,
      0,
      math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 