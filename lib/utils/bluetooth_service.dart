import 'dart:async';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../main.dart' show rootNavigatorKey;
import '../models/device.dart';
import '../providers/app_providers.dart';
import 'distance_zone_helper.dart';
import '../utils/notification_service.dart';

class BluetoothService {
  static final _devicesCtrl = StreamController<List<Device>>.broadcast();
  static final _stateCtrl = StreamController<BluetoothAdapterState>.broadcast();

  static final List<Device> _devices = [];
  static StreamSubscription? _scanSub;
  static StreamSubscription? _stateSub;
  static bool _scanning = false;
  static Timer? _broadcastTimer;
  static const Duration _updateThrottle = Duration(seconds: 2);

  static AndroidDeviceInfo? _androidInfo;

  static Stream<List<Device>> get devicesStream => _devicesCtrl.stream;

  static Stream<BluetoothAdapterState> get stateStream => _stateCtrl.stream;

  static bool get isScanning => _scanning;

  static bool _isFlowActive = false;

  static bool get isFlowActive => _isFlowActive;

  static void startFlow() {
    if (kDebugMode) {
      debugPrint('BluetoothService: startFlow() called - _isFlowActive: $_isFlowActive');
    }
    
    if (!_isFlowActive) {
      _isFlowActive = true;
      if (kDebugMode) {
        debugPrint('BluetoothService: Flow started - fresh start');
      }
    } else {
      if (kDebugMode) {
        debugPrint('BluetoothService: Flow was already active');
      }
    }
  }

  static void stopFlow() {
    if (kDebugMode) {
      debugPrint('BluetoothService: stopFlow() called - _isFlowActive: $_isFlowActive');
    }
    
    if (_isFlowActive) {
      _isFlowActive = false;
      if (kDebugMode) {
        debugPrint('BluetoothService: Flow stopped');
      }
    } else {
      if (kDebugMode) {
        debugPrint('BluetoothService: Flow was already stopped');
      }
    }
    if (kDebugMode) {
      debugPrint('BluetoothService: Calling resetBluetooth() from stopFlow()');
    }
    resetBluetooth();
  }

  static Future<void> resetBluetooth() async {
    if (kDebugMode) {
      debugPrint('BluetoothService: resetBluetooth() called');
    }
    
    await stopScan();
    
    _devices.clear();
    _devicesCtrl.add(List.unmodifiable(_devices));
    _scanning = false;
    _isFlowActive = false;
    
    _broadcastTimer?.cancel();
    _broadcastTimer = null;
    
    await _scanSub?.cancel();
    _scanSub = null;
    
    NotificationService.clearNotificationStates();
    
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      try {
        final container = ProviderScope.containerOf(ctx, listen: false);
        container.read(appStateProvider.notifier).setDiscoveredDevices([]);
        container.read(appStateProvider.notifier).setScanning(false);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('BluetoothService: Could not update Riverpod state during reset: $e');
        }
      }
    }
    
    if (kDebugMode) {
      debugPrint('BluetoothService: Bluetooth completely reset');
    }
  }

  static Future<void> initialize() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _androidInfo = await DeviceInfoPlugin().androidInfo;
    }

    _stateSub = FlutterBluePlus.adapterState.listen((s) {
      _stateCtrl.add(s);
      if (kDebugMode) debugPrint('Adapter state ➜ $s');
    });
    _stateCtrl.add(await FlutterBluePlus.adapterState.first);
  }

  static Future<bool> _checkPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final sdk = _androidInfo?.version.sdkInt ??
          (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      final needed = sdk >= 31
          ? [Permission.bluetoothScan, Permission.bluetoothConnect]
          : [Permission.bluetooth, Permission.location];

      final statuses = await needed.request();
      return statuses.values.every((s) => s.isGranted);
    } else {
      final status = await Permission.bluetooth.request();
      return status.isGranted;
    }
  }

  static Future<bool> ensureReady() async {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      if (kDebugMode) {
        debugPrint('BluetoothService.ensureReady: No context available');
      }
      return false;
    }

    if (!await _checkPermissions()) {
      if (kDebugMode) {
        debugPrint('BluetoothService.ensureReady: Permissions not granted');
      }
      return false;
    }

    if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.off) {
      await _showSettingsDialog(
        ctx,
        'Enable Bluetooth',
        'Turn on Bluetooth to start scanning.',
        androidAction: 'android.settings.BLUETOOTH_SETTINGS',
      );
      return false;
    }

    try {
      await FlutterBluePlus.startScan(
        androidScanMode: AndroidScanMode.lowLatency,
        timeout: const Duration(seconds: 1),
      );
      await FlutterBluePlus.stopScan();
      if (kDebugMode) {
        debugPrint(
            'BluetoothService.ensureReady: Probe scan successful, GPS OK');
      }
      return true;
    } on FlutterBluePlusException catch (e) {
      if (kDebugMode) {
        debugPrint(
            'BluetoothService.ensureReady: FlutterBluePlusException: ${e.toString()}');
      }
      if (e.toString().contains('location') ||
          e.toString().contains('Location')) {
        if (kDebugMode) {
          debugPrint('BluetoothService.ensureReady: Showing location dialog');
        }
        await _showSettingsDialog(
          ctx,
          'Enable Location',
          'Location Services must be ON to scan for BLE devices.',
          androidAction: 'android.settings.LOCATION_SOURCE_SETTINGS',
        );
      }
      return false;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint(
            'BluetoothService.ensureReady: PlatformException: ${e.message}');
      }
      if (e.message?.contains('Location services') == true ||
          e.message?.contains('location') == true) {
        if (kDebugMode) {
          debugPrint('BluetoothService.ensureReady: Showing location dialog');
        }
        await _showSettingsDialog(
          ctx,
          'Enable Location',
          'Location Services must be ON to scan for BLE devices.',
          androidAction: 'android.settings.LOCATION_SOURCE_SETTINGS',
        );
      }
      return false;
    }
  }

  static Future<void> startScan() async {
    if (_scanning) return;
    if (!await ensureReady()) return;

    if (kDebugMode) {
      debugPrint('BluetoothService: Starting scan...');
    }

    _devices.clear();
    _devicesCtrl.add(List.unmodifiable(_devices));
    _devicesCtrl.add(_devices);
    _scanning = true;

    _broadcastTimer?.cancel();
    _broadcastTimer = Timer.periodic(_updateThrottle, (_) => _flushDevices());
    
    _flushDevices();
    
    if (kDebugMode) {
      debugPrint(
          'BluetoothService: Timer created with interval ${_updateThrottle.inSeconds}s');
    }

    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      try {
        final container = ProviderScope.containerOf(ctx, listen: false);
        container.read(appStateProvider.notifier).setScanning(true);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('BluetoothService: Could not update scanning state: $e');
        }
      }
    }

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      if (kDebugMode) {
        debugPrint('BluetoothService: Received ${results.length} scan results');
      }
      for (final r in results) {
        _handleScanResult(r);
      }
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30),
      androidScanMode: AndroidScanMode.lowLatency,
      continuousUpdates: true,
    );

    if (kDebugMode) {
      debugPrint('BluetoothService: Scan started successfully');
    }
  }

  static Future<void> stopScan() async {
    if (kDebugMode) {
      debugPrint('BluetoothService: Stopping scan...');
    }
    
    if (!_scanning) {
      if (kDebugMode) {
        debugPrint('BluetoothService: Scan already stopped, skipping');
      }
      return;
    }
    
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();
    _scanning = false;

    _broadcastTimer?.cancel();
    _broadcastTimer = null;

    _devicesCtrl.add(List.unmodifiable(_devices));

    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      try {
        final container = ProviderScope.containerOf(ctx, listen: false);
        container.read(appStateProvider.notifier).setScanning(false);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('BluetoothService: Could not update scanning state: $e');
        }
      }
    }

    if (kDebugMode) {
      debugPrint('BluetoothService: Scan stopped');
    }
  }

  static void _handleScanResult(ScanResult r) {
    if (!_isFlowActive) {
      if (kDebugMode) {
        debugPrint('BluetoothService: Flow not active, ignoring scan result');
      }
      return;
    }

    if (r.rssi < -90) return;

    if (kDebugMode) {
      debugPrint(
          'BluetoothService: ScanResult for ${r.device.remoteId.str} - RSSI: ${r.rssi}');
    }

    final name = r.advertisementData.advName.isNotEmpty
        ? r.advertisementData.advName
        : r.device.platformName.isNotEmpty
            ? r.device.platformName
            : 'BLE Device ${r.device.remoteId.str.substring(0, 4)}';

    final idx = _devices.indexWhere((d) => d.id == r.device.remoteId.str);

    final meters = DistanceZoneHelper.rssiToMeters(r.rssi);
    final zone = DistanceZoneHelper.rssiToZone(r.rssi);
    final strength = DistanceZoneHelper.rssiToStrength(r.rssi);

    final dev = (idx >= 0 ? _devices[idx] : null)?.copyWith(
          rssi: r.rssi,
          distance: meters,
          zone: zone,
          strength: strength,
          lastSeen: DateTime.now(),
          name: name,
        ) ??
        Device(
          id: r.device.remoteId.str,
          name: name,
          rssi: r.rssi,
          distance: meters,
          zone: zone,
          strength: strength,
          lastSeen: DateTime.now(),
          isConnected: false,
          notifyWhenClose: false,
          deviceType: 'BLE',
          serialNumber: null,
        );

    if (idx >= 0) {
      _devices[idx] = dev;
    } else {
      _devices.add(dev);
    }
  }

  static void _flushDevices() {
    if (!_scanning || !_isFlowActive) return;

    if (kDebugMode) {
      debugPrint(
          'BluetoothService: _flushDevices called - scanning: $_scanning, flow: $_isFlowActive, devices: ${_devices.length}');
    }

    final snapshot = List<Device>.unmodifiable(_devices);
    _devicesCtrl.add(snapshot);

    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      try {
        final container = ProviderScope.containerOf(ctx, listen: false);
        container
            .read(appStateProvider.notifier)
            .setDiscoveredDevices(snapshot);
        
        NotificationService.checkDeviceProximity(container);
        
        if (kDebugMode) {
          debugPrint(
              'BluetoothService: Timer broadcast - ${_devices.length} devices');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('BluetoothService: Could not update Riverpod state: $e');
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            'BluetoothService: No context available for Riverpod update');
      }
    }
  }

  static Future<String?> readSerialNumber(Device device) async {
    return null;
  }

  static Future<void> _showSettingsDialog(
    BuildContext ctx,
    String title,
    String message, {
    String? androidAction,
  }) async {
    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (dCtx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dCtx);
              if (defaultTargetPlatform == TargetPlatform.android &&
                  androidAction != null) {
                await AndroidIntent(action: androidAction).launch();
              } else {
                await openAppSettings();
              }
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  static Future<void> dispose() async {
    await _scanSub?.cancel();
    await _stateSub?.cancel();
    await FlutterBluePlus.stopScan();
    _devicesCtrl.close();
    _stateCtrl.close();
  }
}
