import 'package:flutter/material.dart';

class RssiIndicator extends StatelessWidget {
  final int rssi;
  final double barWidth;
  final double maxHeight;

  const RssiIndicator({
    super.key,
    required this.rssi,
    this.barWidth = 3.0,
    this.maxHeight = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final height = maxHeight * (index + 1) / 4;
        bool isActive = _isBarActive(index);
        Color barColor = _getBarColor(index);
        
        return Container(
          width: barWidth,
          height: maxHeight,
          margin: const EdgeInsets.only(right: 2),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: barWidth,
              height: height,
              decoration: BoxDecoration(
                color: isActive ? barColor : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }

  bool _isBarActive(int index) {
    if (rssi >= -60) {
      return index < 4;
    } else if (rssi >= -70) {
      return index < 3;
    } else if (rssi >= -80) {
      return index < 2;
    } else if (rssi >= -90) {
      return index < 1;
    }
    return false;
  }

  Color _getBarColor(int index) {
    if (rssi >= -60) {
      return Colors.green;
    } else if (rssi >= -70) {
      return Colors.orange;
    } else if (rssi >= -80) {
      return Colors.orange;
    } else if (rssi >= -90) {
      return Colors.red;
    }
    return Colors.red;
  }
} 