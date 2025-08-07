import 'dart:math';
import 'package:flutter/material.dart';

enum DistanceZone { near, medium, far, unknown }
enum RssiStrength { strong, medium, weak, unknown }

class DistanceZoneHelper {
  static double rssiToMeters(int rssi, {int txPower = -59}) =>
      (pow(10, (txPower - rssi) / 20) as double).clamp(0, 30);

  static DistanceZone rssiToZone(int rssi) {
    if (rssi >= -60) return DistanceZone.near;
    if (rssi >= -75) return DistanceZone.medium;
    if (rssi >= -90) return DistanceZone.far;
    return DistanceZone.unknown;
  }

  static RssiStrength rssiToStrength(int rssi) {
    if (rssi >= -60) return RssiStrength.strong;
    if (rssi >= -75) return RssiStrength.medium;
    if (rssi >= -90) return RssiStrength.weak;
    return RssiStrength.unknown;
  }

  static String getDistanceString(DistanceZone z, double m) => switch (z) {
        DistanceZone.near    => '~${m.toStringAsFixed(1)} m',
        DistanceZone.medium  => '~${m.toStringAsFixed(1)} m',
        DistanceZone.far     => '~${m.toStringAsFixed(1)} m',
        DistanceZone.unknown => 'Unknown',
      };

  static String strengthToString(RssiStrength strength) {
    switch (strength) {
      case RssiStrength.strong:
        return 'Strong';
      case RssiStrength.medium:
        return 'Medium';
      case RssiStrength.weak:
        return 'Weak';
      case RssiStrength.unknown:
        return 'Unknown';
    }
  }

  static Color zoneToColor(DistanceZone zone) {
    switch (zone) {
      case DistanceZone.near:
        return const Color(0xFF4CAF50);
      case DistanceZone.medium:
        return const Color(0xFFFF9800);
      case DistanceZone.far:
        return const Color(0xFFF44336);
      case DistanceZone.unknown:
        return Colors.grey;
    }
  }
} 