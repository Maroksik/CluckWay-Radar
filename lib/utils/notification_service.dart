import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/device.dart';
import '../providers/app_providers.dart';
import '../utils/storage_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  
  static final Map<String, bool> _notificationStates = {};

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> showDeviceFoundNotification(Device device) async {
    const androidDetails = AndroidNotificationDetails(
      'device_tracking',
      'Device Tracking',
      channelDescription: 'Notifications for device proximity',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      device.hashCode,
      'Device Found!',
      '${device.name} is nearby (within 2 meters)',
      details,
    );
  }

  static Future<void> showDeviceLostNotification(Device device) async {
    const androidDetails = AndroidNotificationDetails(
      'device_tracking',
      'Device Tracking',
      channelDescription: 'Notifications for device proximity',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      device.hashCode + 1000,
      'Device Lost',
      '${device.name} is no longer nearby',
      details,
    );
  }

  static Future<void> checkDeviceProximity(ProviderContainer container) async {
    final appState = container.read(appStateProvider);
    final trackingDevices = appState.myDevices.where((device) {
      return StorageService.isDeviceTrackingEnabled(device.id);
    }).toList();

    if (kDebugMode) {
      debugPrint('NotificationService: Checking ${trackingDevices.length} tracking devices');
      debugPrint('NotificationService: Current notification states: $_notificationStates');
    }

    final discoveredDevices = appState.discoveredDevices;

    for (final trackingDevice in trackingDevices) {
      try {
        final liveDevice = discoveredDevices.firstWhere(
          (d) => d.id == trackingDevice.id,
        );
        
        if (kDebugMode) {
          debugPrint('NotificationService: Device ${liveDevice.name} - Distance: ${liveDevice.distance.toStringAsFixed(1)}m, RSSI: ${liveDevice.rssi}');
        }
        
        if (liveDevice.distance <= 2.0) {
          if (!_notificationStates.containsKey(liveDevice.id) || !_notificationStates[liveDevice.id]!) {
            await showDeviceFoundNotification(liveDevice);
            _notificationStates[liveDevice.id] = true;
            if (kDebugMode) {
              debugPrint('NotificationService: Device ${liveDevice.name} is within 2m (${liveDevice.distance.toStringAsFixed(1)}m) - NOTIFICATION SENT!');
            }
          } else {
            if (kDebugMode) {
              debugPrint('NotificationService: Device ${liveDevice.name} already notified, skipping');
            }
          }
        } else {
          if (_notificationStates.containsKey(liveDevice.id) && _notificationStates[liveDevice.id]!) {
            _notificationStates[liveDevice.id] = false;
            if (kDebugMode) {
              debugPrint('NotificationService: Device ${liveDevice.name} left 2m range, reset notification state');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('NotificationService: Device ${trackingDevice.name} not found in discovered devices');
        }
      }
    }
  }

  static Future<void> requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static void clearNotificationStates() {
    _notificationStates.clear();
    if (kDebugMode) {
      debugPrint('NotificationService: Cleared notification states');
    }
  }
} 