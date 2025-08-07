import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../utils/bluetooth_service.dart';

class SearchStartScreen extends ConsumerWidget {
  const SearchStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          debugPrint('SearchStartScreen: Back button pressed - calling stopFlow()');
                        }
                        BluetoothService.stopFlow();
                        context.go(AppConstants.menuRoute);
                      },
                      icon: Image.asset(
                        'assets/images/ic_arrow_back.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Search for devices',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/images/ic_finding.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      BluetoothService.startFlow();
                      context.go(AppConstants.myDevicesRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius),
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: const Text(
                      'My devices',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      debugPrint('SearchStartScreen: Start searching button pressed');
                      try {
                        final ready = await BluetoothService.ensureReady();
                        debugPrint('SearchStartScreen: Bluetooth ready: $ready');
                        if (!ready) {
                          debugPrint('SearchStartScreen: Bluetooth not ready, returning');
                          return;
                        }
                        debugPrint('SearchStartScreen: Starting flow and scan');
                        BluetoothService.startFlow();
                        await BluetoothService.startScan();
                        if (context.mounted) {
                          debugPrint('SearchStartScreen: Navigating to search loading');
                          context.go(AppConstants.searchLoadingRoute);
                        }
                      } catch (e) {
                        debugPrint('SearchStartScreen: Error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                    ),
                    child: const Text(
                      'Start searching',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
