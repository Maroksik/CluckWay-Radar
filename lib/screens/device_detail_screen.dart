import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../utils/distance_zone_helper.dart';
import '../models/device.dart';
import '../providers/app_providers.dart';
import '../widgets/rssi_indicator.dart';
import '../utils/bluetooth_service.dart';

class DeviceDetailScreen extends ConsumerStatefulWidget {
  final String deviceId;
  final String? source;

  const DeviceDetailScreen({
    super.key, 
    required this.deviceId,
    this.source,
  });

  @override
  ConsumerState<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _dotAnimationController;
  late Animation<double> _dotAnimation;
  Device? _device;
  bool _showTrackingInfo = false;

  @override
  void initState() {
    super.initState();
    _dotAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _dotAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dotAnimationController, curve: Curves.easeInOut),
    );
    _loadDevice();
    
    if (!BluetoothService.isScanning) {
      BluetoothService.startScan();
    }
  }

  @override
  void dispose() {
    _dotAnimationController.dispose();
    super.dispose();
  }

  void _loadDevice() {
    final discoveredDevices = ref.read(appStateProvider.select((s) => s.discoveredDevices));
    final connectedDevices = ref.read(appStateProvider.select((s) => s.connectedDevices));
    
    _device = discoveredDevices.firstWhere(
      (d) => d.id == widget.deviceId,
      orElse: () => connectedDevices.firstWhere(
        (d) => d.id == widget.deviceId,
        orElse: () => _createFallbackDevice(),
      ),
    );
    
    _animateDotToZone(_device!.zone);
  }

  Device _createFallbackDevice() {
    return Device(
      id: widget.deviceId,
      name: 'Unknown Device',
      rssi: -65,
      distance: DistanceZoneHelper.rssiToMeters(-65),
      zone: DistanceZoneHelper.rssiToZone(-65),
      strength: DistanceZoneHelper.rssiToStrength(-65),
      lastSeen: DateTime.now(),
      isConnected: false,
      notifyWhenClose: false,
      serialNumber: null,
      deviceType: null,
    );
  }

  void _animateDotToZone(DistanceZone zone) {
    final double targetPosition = switch (zone) {
      DistanceZone.near => 0.0,
      DistanceZone.medium => 0.5,
      DistanceZone.far => 1.0,
      DistanceZone.unknown => 1.0,
    };
    
    _dotAnimation = Tween<double>(
      begin: _dotAnimation.value,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: _dotAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _dotAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<Device>>(
      appStateProvider.select((s) => s.discoveredDevices),
      (_, devices) {
        try {
          final updated = devices.firstWhere((d) => d.id == widget.deviceId);
          if (mounted && _device != null && updated.rssi != _device!.rssi) {
            setState(() {
              _device = updated;
            });
            _animateDotToZone(updated.zone);
            if (kDebugMode) {
              debugPrint('DeviceDetailScreen: Updated device ${updated.name} - RSSI: ${updated.rssi}, Distance: ${updated.distance} at ${DateTime.now()}');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('DeviceDetailScreen: Device ${widget.deviceId} not found in discovered devices');
          }
        }
      },
    );

    if (_device == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final myDevices = ref.watch(appStateProvider.select((s) => s.myDevices));
    final isInMyDevices = myDevices.any((d) => d.id == widget.deviceId);
    final isFromSearch = widget.source == 'search';
    final isFromMyDevices = widget.source == 'myDevices';

    if (kDebugMode) {
      debugPrint('DeviceDetailScreen: Device ${_device?.name} - isFromSearch: $isFromSearch, isFromMyDevices: $isFromMyDevices, isInMyDevices: $isInMyDevices');
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.source == 'search') {
                              context.go('/search/results');
                            } else if (widget.source == 'myDevices') {
                              context.go('/my-devices');
                            } else {
                              Navigator.of(context).pop();
                            }
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
                              isFromMyDevices ? 'My devices' : 'Search for devices',
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
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _device!.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bluetooth,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DistanceZoneHelper.getDistanceString(_device!.zone, _device!.distance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('RSSI', DistanceZoneHelper.strengthToString(_device!.strength), _buildRssiIndicator()),
                          const SizedBox(height: 12),
                          _buildInfoRow('Device type', _device!.deviceType ?? 'Unknown'),
                          const SizedBox(height: 12),
                          _buildInfoRow('Serial number', _device!.serialNumber ?? 'Unknown'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: ref.watch(appStateProvider.select((s) => 
                                s.myDevices.any((d) => d.id == widget.deviceId) 
                                  ? s.myDevices.firstWhere((d) => d.id == widget.deviceId).notifyWhenClose 
                                  : false)),
                              onChanged: (value) async {
                                if (!isInMyDevices) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          "You can enable tracking only for devices from 'My devices'.",
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 3),
                                        margin: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  return;
                                }

                                final newValue = value ?? false;
                                await ref
                                    .read(appStateProvider.notifier)
                                    .setDeviceTracking(widget.deviceId, newValue);
                              },
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                            ),
                            const Text(
                              'add for tracking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showTrackingInfo = !_showTrackingInfo;
                                });
                              },
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.white.withValues(alpha: 0.7),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          'Move to a location where the signal strength is stronger',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: AnimatedBuilder(
                            animation: _dotAnimation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: EnhancedConcentricRingsPainter(
                                  zone: _device!.zone,
                                  dotPosition: _dotAnimation.value,
                                  rssi: _device!.rssi,
                                ),
                                size: const Size(250, 250),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isFromSearch && !isInMyDevices) {
                            if (kDebugMode) {
                              debugPrint('DeviceDetailScreen: Adding device ${_device!.name} to my devices');
                            }
                            await ref.read(appStateProvider.notifier).addDeviceToMyDevices(_device!);
                            if (mounted) {
                              context.go('/search/results');
                            }
                          } else if (isFromMyDevices) {
                            if (kDebugMode) {
                              debugPrint('DeviceDetailScreen: Removing device ${_device!.name} from my devices (from my devices)');
                            }
                            await ref.read(appStateProvider.notifier).removeDeviceFromMyDevices(widget.deviceId);
                            if (mounted) {
                              context.go('/my-devices');
                            }
                          } else if (isFromSearch && isInMyDevices) {
                            if (kDebugMode) {
                              debugPrint('DeviceDetailScreen: Removing device ${_device!.name} from my devices (from search)');
                            }
                            await ref.read(appStateProvider.notifier).removeDeviceFromMyDevices(widget.deviceId);
                            if (mounted) {
                              context.go('/search/results');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                          ),
                        ),
                        child: Text(
                          isFromSearch && !isInMyDevices 
                              ? 'Add to my devices' 
                              : 'Delete from my devices',
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
              
              if (_showTrackingInfo)
                Positioned(
                  top: 380,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'When the device appears within a 2 meter radius, a push notification will be sent to the phone',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showTrackingInfo = false;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRssiIndicator() {
    return RssiIndicator(
      rssi: _device!.rssi,
    );
  }

  Widget _buildInfoRow(String label, String value, [Widget? customValue]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        ...(customValue != null ? [
          const SizedBox(width: 8),
          customValue,
        ] : []),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class EnhancedConcentricRingsPainter extends CustomPainter {
  final DistanceZone zone;
  final double dotPosition;
  final int rssi;

  EnhancedConcentricRingsPainter({
    required this.zone,
    required this.dotPosition,
    required this.rssi,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 15;

    for (int i = 0; i < 6; i++) {
      final radius = maxRadius * (i + 1) / 6;
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paint);
    }

    final activeRingIndex = _getActiveRingIndex();
    if (activeRingIndex >= 0) {
      final activeRadius = maxRadius * (activeRingIndex + 1) / 6;
      final activePaint = Paint()
        ..color = Colors.green.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawCircle(center, activeRadius, activePaint);
    }

    final youPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 6, youPaint);

    final youTextPainter = TextPainter(
      text: const TextSpan(
        text: 'You',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    youTextPainter.layout();
    youTextPainter.paint(
      canvas,
      Offset(
        center.dx - youTextPainter.width / 2,
        center.dy + 15,
      ),
    );

    final dotRadius = 8.0;
    final dotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final distance = _calculateDistanceFromRssi();
    final direction = _calculateDirectionFromRssi();
    
    final dotOffset = Offset(
      center.dx + (distance * 0.8) * direction.dx,
      center.dy + (distance * 0.8) * direction.dy,
    );

    canvas.drawCircle(dotOffset, dotRadius, dotPaint);

    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final arrowStart = Offset(
      center.dx + (distance * 0.4) * direction.dx,
      center.dy + (distance * 0.4) * direction.dy,
    );
    final arrowEnd = Offset(
      center.dx + (distance * 0.6) * direction.dx,
      center.dy + (distance * 0.6) * direction.dy,
    );

    canvas.drawLine(arrowStart, arrowEnd, arrowPaint);

    final badgeRect = Rect.fromCenter(
      center: Offset(dotOffset.dx - 30, dotOffset.dy - 20),
      width: 60,
      height: 24,
    );

    final badgePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, const Radius.circular(12)),
      badgePaint,
    );

    final distanceTextPainter = TextPainter(
      text: TextSpan(
        text: '~${DistanceZoneHelper.rssiToMeters(rssi).toStringAsFixed(1)} m',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    distanceTextPainter.layout();
    distanceTextPainter.paint(
      canvas,
      Offset(
        badgeRect.center.dx - distanceTextPainter.width / 2,
        badgeRect.center.dy - distanceTextPainter.height / 2,
      ),
    );
  }

  int _getActiveRingIndex() {
    if (rssi >= -60) return 0;
    if (rssi >= -70) return 1;
    if (rssi >= -80) return 2;
    if (rssi >= -90) return 3;
    return -1;
  }

  double _calculateDistanceFromRssi() {
    return DistanceZoneHelper.rssiToMeters(rssi) / 30.0;
  }

  Offset _calculateDirectionFromRssi() {
    final angle = (rssi % 360) * (3.14159 / 180);
    return Offset(cos(angle), sin(angle));
  }

  @override
  bool shouldRepaint(EnhancedConcentricRingsPainter oldDelegate) {
    return oldDelegate.zone != zone || 
           oldDelegate.dotPosition != dotPosition ||
           oldDelegate.rssi != rssi;
  }
} 