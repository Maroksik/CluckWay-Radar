import 'package:flutter/material.dart';

const int rssiStrongThreshold = -60;
const int rssiMediumThreshold = -80;
const int rssiWeakThreshold = -90;

class AppColors {
  static const Color primaryGradientStart = Color(0xFF0F0052);
  static const Color primaryGradientEnd = Color(0xFF0B007F);
  static const Color zoneGreen = Color(0xFF4CAF50);
  static const Color zoneAmber = Color(0xFFFF9800);
  static const Color zoneRed = Color(0xFFF44336);
  static const Color buttonColor = Colors.white;
  static const Color buttonTextColor = Colors.black;
}

const double buttonRadius = 12.0;

const Duration animationDuration = Duration(milliseconds: 300);

const int notificationThreshold = 2;

const String appStateBox = 'app_state';
const String onboardingSeenKey = 'onboardingSeen';

class AppConstants {
  static const String onboardingRoute = '/onboarding';
  static const String menuRoute = '/menu';
  static const String searchRoute = '/search';
  static const String searchLoadingRoute = '/search/loading';
  static const String searchResultsRoute = '/search/results';
  static const String myDevicesRoute = '/my-devices';
  static const String deviceDetailRoute = '/device/:id';
  static const String securityTipsRoute = '/tips';
  static const String securityTipDetailRoute = '/tips/:id';
  static const String securityTestRoute = '/test';
  static const String securityTestResultRoute = '/test/result';
  static const String settingsRoute = '/settings';
  
  static const String tipsRoute = '/tips';
  static const String testRoute = '/test';
  static const String tipDetailRoute = '/tips/:id';
  static const String testResultRoute = '/test/result';
  
  static const String appStateBoxName = 'app_state';
  static const Color primaryGradientStart = Color(0xFF0F0052);
  static const Color primaryGradientEnd = Color(0xFF0B007F);
  static const Color buttonColor = Colors.white;
  static const Color buttonTextColor = Colors.black;
  static const double buttonRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
} 