import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/distance_zone_helper.dart';

class ConcentricRings extends StatelessWidget {
  final DistanceZone zone;
  final double size;
  final int rssi;

  const ConcentricRings({
    super.key,
    required this.zone,
    required this.rssi,
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ConcentricRingsPainter(zone: zone, rssi: rssi),
    );
  }
}

class ConcentricRingsPainter extends CustomPainter {
  final DistanceZone zone;
  final int rssi;

  ConcentricRingsPainter({required this.zone, required this.rssi});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    paint.color = AppColors.zoneRed;
    canvas.drawCircle(center, maxRadius, paint);

    paint.color = AppColors.zoneAmber;
    canvas.drawCircle(center, maxRadius * 0.67, paint);

    paint.color = AppColors.zoneGreen;
    canvas.drawCircle(center, maxRadius * 0.33, paint);

    final dotPaint = Paint()
      ..color = _getZoneColor()
      ..style = PaintingStyle.fill;

    final radius = switch (zone) {
      DistanceZone.near => maxRadius * 0.3,
      DistanceZone.medium => maxRadius * 0.6,
      DistanceZone.far => maxRadius * 0.9,
      DistanceZone.unknown => maxRadius * 0.6,
    };

    canvas.drawCircle(center, radius, dotPaint);
  }

  Color _getZoneColor() {
    return switch (zone) {
      DistanceZone.near => AppColors.zoneGreen,
      DistanceZone.medium => AppColors.zoneAmber,
      DistanceZone.far => AppColors.zoneRed,
      DistanceZone.unknown => AppColors.zoneAmber,
    };
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ConcentricRingsPainter) {
      return oldDelegate.zone != zone || oldDelegate.rssi != rssi;
    }
    return true;
  }
} 