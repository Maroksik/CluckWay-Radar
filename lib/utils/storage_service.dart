import 'package:hive_flutter/hive_flutter.dart';
import '../models/security_question.dart';
import '../models/device.dart';

class StorageService {
  static const String _appStateBoxName = 'app_state';
  static const String _onboardingSeenKey = 'onboardingSeen';
  static const String _connectedDeviceIdsKey = 'connectedDeviceIds';
  static const String _deviceNotificationsKey = 'deviceNotifications';
  static const String _testResultsKey = 'testResults';
  static const String _myDevicesKey = 'myDevices';
  static const String _deviceTrackingKey = 'deviceTracking';

  static Future<void> initialize() async {
    await Hive.openBox(_appStateBoxName);
  }

  static bool getOnboardingSeen() {
    final box = Hive.box(_appStateBoxName);
    return box.get(_onboardingSeenKey, defaultValue: false);
  }

  static Future<void> setOnboardingSeen(bool value) async {
    final box = Hive.box(_appStateBoxName);
    await box.put(_onboardingSeenKey, value);
  }

  static List<Device> getMyDevices() {
    final box = Hive.box(_appStateBoxName);
    final List<dynamic> devicesData = box.get(_myDevicesKey, defaultValue: []);
    return devicesData.map((deviceData) {
      final Map<String, dynamic> deviceMap = Map<String, dynamic>.from(deviceData);
      return Device.fromMap(deviceMap);
    }).toList();
  }

  static Future<void> saveMyDevices(List<Device> devices) async {
    final box = Hive.box(_appStateBoxName);
    final devicesData = devices.map((device) => device.toMap()).toList();
    await box.put(_myDevicesKey, devicesData);
  }

  static Future<void> addDeviceToMyDevices(Device device) async {
    final devices = getMyDevices();
    if (!devices.any((d) => d.id == device.id)) {
      devices.add(device);
      await saveMyDevices(devices);
    }
  }

  static Future<void> removeDeviceFromMyDevices(String deviceId) async {
    final devices = getMyDevices();
    devices.removeWhere((d) => d.id == deviceId);
    await saveMyDevices(devices);
  }

  static Map<String, bool> getDeviceTracking() {
    final box = Hive.box(_appStateBoxName);
    final Map<String, dynamic> tracking = Map<String, dynamic>.from(
      box.get(_deviceTrackingKey, defaultValue: {}),
    );
    return tracking.map((key, value) => MapEntry(key, value as bool));
  }

  static Future<void> setDeviceTracking(String deviceId, bool enabled) async {
    final box = Hive.box(_appStateBoxName);
    final Map<String, dynamic> tracking = Map<String, dynamic>.from(
      box.get(_deviceTrackingKey, defaultValue: {}),
    );
    tracking[deviceId] = enabled;
    await box.put(_deviceTrackingKey, tracking);
  }

  static bool isDeviceTrackingEnabled(String deviceId) {
    final tracking = getDeviceTracking();
    return tracking[deviceId] ?? false;
  }

  static List<String> get connectedDeviceIds {
    final box = Hive.box(_appStateBoxName);
    final List<dynamic> ids = box.get(_connectedDeviceIdsKey, defaultValue: []);
    return ids.cast<String>();
  }

  static Future<void> addConnectedDevice(String deviceId) async {
    final box = Hive.box(_appStateBoxName);
    final List<String> ids = List<String>.from(connectedDeviceIds);
    if (!ids.contains(deviceId)) {
      ids.add(deviceId);
      await box.put(_connectedDeviceIdsKey, ids);
    }
  }

  static Future<void> removeConnectedDevice(String deviceId) async {
    final box = Hive.box(_appStateBoxName);
    final List<String> ids = List<String>.from(connectedDeviceIds);
    ids.remove(deviceId);
    await box.put(_connectedDeviceIdsKey, ids);
  }

  static Future<void> setDeviceNotification(String deviceId, bool enabled) async {
    final box = Hive.box(_appStateBoxName);
    final Map<String, dynamic> notifications = Map<String, dynamic>.from(
      box.get(_deviceNotificationsKey, defaultValue: {}),
    );
    notifications[deviceId] = enabled;
    await box.put(_deviceNotificationsKey, notifications);
  }

  static bool isDeviceNotificationEnabled(String deviceId) {
    final box = Hive.box(_appStateBoxName);
    final Map<String, dynamic> notifications = Map<String, dynamic>.from(
      box.get(_deviceNotificationsKey, defaultValue: {}),
    );
    return notifications[deviceId] ?? false;
  }

  static Future<void> saveTestResult(SecurityTestResult result) async {
    final box = Hive.box(_appStateBoxName);
    final List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(
      box.get(_testResultsKey, defaultValue: []),
    );
    results.add({
      'score': result.score,
      'category': result.category,
      'recommendation': result.recommendation,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await box.put(_testResultsKey, results);
  }

  static List<SecurityTestResult> get testResults {
    final box = Hive.box(_appStateBoxName);
    final List<dynamic> results = box.get(_testResultsKey, defaultValue: []);
    return results.map((result) => SecurityTestResult(
      score: result['score'],
      category: result['category'],
      recommendation: result['recommendation'],
    )).toList();
  }

  static Future<void> clearTestResults() async {
    final box = Hive.box(_appStateBoxName);
    await box.put(_testResultsKey, []);
  }
} 