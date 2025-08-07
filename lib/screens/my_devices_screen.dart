import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../utils/distance_zone_helper.dart';
import '../models/device.dart';
import '../providers/app_providers.dart';
import '../widgets/rssi_indicator.dart';
import '../utils/bluetooth_service.dart';

class MyDevicesScreen extends ConsumerStatefulWidget {
  const MyDevicesScreen({super.key});

  @override
  ConsumerState<MyDevicesScreen> createState() => _MyDevicesScreenState();
}

class _MyDevicesScreenState extends ConsumerState<MyDevicesScreen> {

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
    final myDevices = ref.watch(appStateProvider.select((s) => s.myDevices));
    final discoveredDevices = ref.watch(appStateProvider.select((s) => s.discoveredDevices));

    ref.listen<List<Device>>(
      appStateProvider.select((s) => s.discoveredDevices),
      (_, devices) {
        if (mounted) {
          setState(() {
          });
        }
      },
    );
    
    final updatedMyDevices = myDevices.map((myDevice) {
      try {
        final liveDevice = discoveredDevices.firstWhere(
          (d) => d.id == myDevice.id,
        );
        return liveDevice;
      } catch (e) {
        return myDevice;
      }
    }).toList();
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
                          debugPrint('MyDevicesScreen: Back button pressed - calling stopFlow()');
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
                          'My devices',
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
                const SizedBox(height: 18),
                Image.asset(
                  'assets/images/ic_bluetooth.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: updatedMyDevices.isEmpty
                      ? const Center(
                          child: Text('No devices added',
                              style: TextStyle(color: Colors.white70)))
                      : ListView.builder(
                          itemCount: updatedMyDevices.length,
                          itemBuilder: (context, index) {
                            final device = updatedMyDevices[index];
                            return GestureDetector(
                              onTap: () => context
                                  .go('/device/${device.id}?source=myDevices'),
                              child: _buildDeviceCard(device),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(Device device) {
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
                    'now',
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
}
