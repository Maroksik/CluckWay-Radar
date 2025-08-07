import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/bluetooth_service.dart';
import '../utils/constants.dart';
import '../utils/distance_zone_helper.dart';
import '../models/device.dart';
import '../providers/app_providers.dart';
import '../widgets/rssi_indicator.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {

  @override
  void initState() {
    super.initState();
    if (!BluetoothService.isScanning) {
      BluetoothService.startScan();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoveredDevices = ref.watch(appStateProvider.select((s) => s.discoveredDevices));
    final myDevices = ref.watch(appStateProvider.select((s) => s.myDevices));
    final isScanning = ref.watch(appStateProvider.select((s) => s.isScanning));

    ref.listen<List<Device>>(
      appStateProvider.select((s) => s.discoveredDevices),
      (_, devices) {
        if (mounted) {
          setState(() {
          });
        }
      },
    );

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
                      onPressed: () async {
                        if (kDebugMode) {
                          debugPrint('SearchResultsScreen: Back button pressed - calling stopFlow()');
                        }
                        BluetoothService.stopFlow();
                        context.go(AppConstants.searchRoute);
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

                Image.asset(
                  'assets/images/ic_bluetooth.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 32),

                Expanded(
                  child: discoveredDevices.isEmpty
                      ? _buildNoResultsMessage()
                      : ListView.builder(
                          itemCount: discoveredDevices.length,
                          itemBuilder: (context, index) {
                            final device = discoveredDevices[index];
                            final isInMyDevices =
                                myDevices.any((d) => d.id == device.id);
                            return GestureDetector(
                              onTap: () =>
                                  context.go('/device/${device.id}?source=search'),
                              child: _buildDeviceCard(device, isInMyDevices),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isScanning) {
                        await BluetoothService.stopScan();
                      } else {
                        await BluetoothService.startScan();
                        context.go(AppConstants.searchLoadingRoute);
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
                    child: Text(
                      isScanning 
                          ? 'Stop scanning'
                          : (discoveredDevices.isEmpty ? 'Try again' : 'Search again'),
                      style: const TextStyle(
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

  Widget _buildDeviceCard(Device device, bool isInMyDevices) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            RssiIndicator(
              barWidth: 6,
              maxHeight: 30,
              rssi: device.rssi,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTimeAgo(device),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DistanceZoneHelper.getDistanceString(device.zone, device.distance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 45,
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(Device device) {
    final ago = DateTime.now().difference(device.lastSeen);
    final timeStr = ago.inSeconds < 5
        ? 'now'
        : '${ago.inSeconds} sec ago';
    return timeStr;
  }

  Widget _buildNoResultsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          
          const Text(
            'No devices found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'No Bluetooth devices were found nearby.\nTry searching again or check your Bluetooth settings.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
