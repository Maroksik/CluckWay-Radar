import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/device.dart';
import '../models/security_tip.dart';
import '../models/security_question.dart';
import '../utils/storage_service.dart';
import '../utils/bluetooth_service.dart';

import '../utils/constants.dart';
import '../screens/onboarding_screen.dart';
import '../screens/main_menu_screen.dart';
import '../screens/search_start_screen.dart';
import '../screens/search_loading_screen.dart';
import '../screens/search_results_screen.dart';
import '../screens/my_devices_screen.dart';
import '../screens/device_detail_screen.dart';
import '../screens/security_tips_screen.dart';
import '../screens/security_tip_detail_screen.dart';
import '../screens/security_test_screen.dart';
import '../screens/security_test_result_screen.dart';
import '../screens/settings_screen.dart';

class AppState {
  final bool onboardingSeen;
  final List<Device> discoveredDevices;
  final List<Device> connectedDevices;
  final List<Device> myDevices;
  final bool isScanning;
  final List<SecurityTip> securityTips;
  final List<SecurityQuestion> securityQuestions;
  final Map<String, int> testAnswers;
  final SecurityTestResult? testResult;

  AppState({
    required this.onboardingSeen,
    required this.discoveredDevices,
    required this.connectedDevices,
    required this.myDevices,
    required this.isScanning,
    required this.securityTips,
    required this.securityQuestions,
    required this.testAnswers,
    this.testResult,
  });

  AppState copyWith({
    bool? onboardingSeen,
    List<Device>? discoveredDevices,
    List<Device>? connectedDevices,
    List<Device>? myDevices,
    bool? isScanning,
    List<SecurityTip>? securityTips,
    List<SecurityQuestion>? securityQuestions,
    Map<String, int>? testAnswers,
    SecurityTestResult? testResult,
  }) {
    return AppState(
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      connectedDevices: connectedDevices ?? this.connectedDevices,
      myDevices: myDevices ?? this.myDevices,
      isScanning: isScanning ?? this.isScanning,
      securityTips: securityTips ?? this.securityTips,
      securityQuestions: securityQuestions ?? this.securityQuestions,
      testAnswers: testAnswers ?? this.testAnswers,
      testResult: testResult ?? this.testResult,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState(
    onboardingSeen: StorageService.getOnboardingSeen(),
    discoveredDevices: [],
    connectedDevices: [],
    myDevices: StorageService.getMyDevices(),
    isScanning: false,
    securityTips: [],
    securityQuestions: [],
    testAnswers: {},
  )) {
    _initializeBluetooth();
  }

  void _initializeBluetooth() {
    BluetoothService.initialize();
    
    BluetoothService.stateStream.listen((state) {
      debugPrint('Bluetooth state in provider: $state');
    });

    BluetoothService.devicesStream.listen((devices) {
      state = state.copyWith(discoveredDevices: devices);
    });
  }

  Future<void> setOnboardingSeen(bool seen) async {
    StorageService.setOnboardingSeen(seen);
    state = state.copyWith(onboardingSeen: seen);
  }

  Future<void> startScan() async {
    debugPrint('AppStateNotifier: Starting scan...');
    state = state.copyWith(isScanning: true, discoveredDevices: []);
    await BluetoothService.startScan();
  }

  Future<void> stopScan() async {
    BluetoothService.stopScan();
    state = state.copyWith(isScanning: false);
    debugPrint('AppStateNotifier: Scan stopped');
  }

  void updateDiscoveredDevices(List<Device> devices) {
    state = state.copyWith(discoveredDevices: devices);
  }

  void setDiscoveredDevices(List<Device> devices) {
    state = state.copyWith(discoveredDevices: devices);
  }

  void setScanning(bool scanning) {
    state = state.copyWith(isScanning: scanning);
    debugPrint('AppStateNotifier: Scanning set to $scanning');
  }

  void updateConnectedDevices(List<Device> devices) {
    state = state.copyWith(connectedDevices: devices);
  }

  Future<void> addDeviceToMyDevices(Device device) async {
    if (!state.myDevices.any((d) => d.id == device.id)) {
      final updatedDevices = [...state.myDevices, device];
      state = state.copyWith(myDevices: updatedDevices);
      await StorageService.saveMyDevices(updatedDevices);
    }
  }

  Future<void> removeDeviceFromMyDevices(String deviceId) async {
    if (kDebugMode) {
      debugPrint('AppStateNotifier: Removing device $deviceId from my devices');
      debugPrint('AppStateNotifier: Current myDevices count: ${state.myDevices.length}');
    }
    final updatedDevices = state.myDevices.where((d) => d.id != deviceId).toList();
    state = state.copyWith(myDevices: updatedDevices);
    await StorageService.saveMyDevices(updatedDevices);
    if (kDebugMode) {
      debugPrint('AppStateNotifier: Updated myDevices count: ${updatedDevices.length}');
    }
  }

  bool isDeviceInMyDevices(String deviceId) {
    return state.myDevices.any((d) => d.id == deviceId);
  }

  Future<void> setDeviceTracking(String deviceId, bool enabled) async {
    await StorageService.setDeviceTracking(deviceId, enabled);
    
    final updatedDevices = state.myDevices.map((device) {
      if (device.id == deviceId) {
        return device.copyWith(notifyWhenClose: enabled);
      }
      return device;
    }).toList();
    
    state = state.copyWith(myDevices: updatedDevices);
    await StorageService.saveMyDevices(updatedDevices);
  }

  bool isDeviceTrackingEnabled(String deviceId) {
    return StorageService.isDeviceTrackingEnabled(deviceId);
  }

  Future<void> connectToDevice(Device device) async {
    final updatedConnectedDevices = [...state.connectedDevices, device];
    state = state.copyWith(connectedDevices: updatedConnectedDevices);
  }

  Future<void> disconnectFromDevice(Device device) async {
    final updatedConnectedDevices = state.connectedDevices.where((d) => d.id != device.id).toList();
    state = state.copyWith(connectedDevices: updatedConnectedDevices);
  }

  void updateTestAnswers(String questionId, int answerIndex) {
    final updatedAnswers = Map<String, int>.from(state.testAnswers);
    updatedAnswers[questionId] = answerIndex;
    state = state.copyWith(testAnswers: updatedAnswers);
  }

  void setTestResult(SecurityTestResult result) {
    state = state.copyWith(testResult: result);
  }

  void clearTestResult() {
    state = state.copyWith(testResult: null, testAnswers: {});
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingSeen = ref.watch(appStateProvider.select((s) => s.onboardingSeen));
  
  return GoRouter(
    initialLocation: onboardingSeen ? AppConstants.menuRoute : AppConstants.onboardingRoute,
    routes: [
      GoRoute(
        path: AppConstants.onboardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.menuRoute,
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: AppConstants.searchRoute,
        builder: (context, state) => const SearchStartScreen(),
      ),
      GoRoute(
        path: AppConstants.searchLoadingRoute,
        builder: (context, state) => const SearchLoadingScreen(),
      ),
      GoRoute(
        path: AppConstants.searchResultsRoute,
        builder: (context, state) => const SearchResultsScreen(),
      ),
      GoRoute(
        path: AppConstants.myDevicesRoute,
        builder: (context, state) => const MyDevicesScreen(),
      ),
      GoRoute(
        path: AppConstants.deviceDetailRoute,
        builder: (context, state) {
          final deviceId = state.pathParameters['id']!;
          final source = state.uri.queryParameters['source'];
          return DeviceDetailScreen(deviceId: deviceId, source: source);
        },
      ),
      GoRoute(
        path: AppConstants.tipsRoute,
        builder: (context, state) => const SecurityTipsScreen(),
      ),
      GoRoute(
        path: AppConstants.securityTipDetailRoute,
        builder: (context, state) {
          final tipId = state.pathParameters['id']!;
          return SecurityTipDetailScreen(tipId: tipId);
        },
      ),
      GoRoute(
        path: AppConstants.testRoute,
        builder: (context, state) => const SecurityTestScreen(),
      ),
      GoRoute(
        path: AppConstants.securityTestResultRoute,
        builder: (context, state) => const SecurityTestResultScreen(),
      ),
      GoRoute(
        path: AppConstants.settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}); 