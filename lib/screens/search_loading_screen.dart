import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/bluetooth_service.dart';
import '../utils/constants.dart';
import '../providers/app_providers.dart';

class SearchLoadingScreen extends ConsumerStatefulWidget {
  const SearchLoadingScreen({super.key});

  @override
  ConsumerState<SearchLoadingScreen> createState() => _SearchLoadingScreenState();
}

class _SearchLoadingScreenState extends ConsumerState<SearchLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!BluetoothService.isScanning) {
        await BluetoothService.startScan();
      }
      
      _scanTimer = Timer(const Duration(seconds: 30), () {
        if (mounted) {
          debugPrint('SearchLoading: 30 seconds timer expired, navigating to results');
          context.go(AppConstants.searchResultsRoute);
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoveredDevices = ref.watch(appStateProvider.select((s) => s.discoveredDevices));
    final isScanning = ref.watch(appStateProvider.select((s) => s.isScanning));
    
    debugPrint('SearchLoading: discoveredDevices=${discoveredDevices.length}, isScanning=$isScanning');
    
    if (discoveredDevices.isNotEmpty && isScanning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          debugPrint('SearchLoading: Devices found and scanning active, navigating to results - devices: ${discoveredDevices.length}');
          _scanTimer?.cancel();
          context.go(AppConstants.searchResultsRoute);
        }
      });
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        debugPrint('SearchLoading: Back button pressed, stopping scan');
                        _scanTimer?.cancel();
                        await BluetoothService.stopScan();
                        ref.read(appStateProvider.notifier).stopScan();
                        if (mounted) {
                          context.go(AppConstants.searchRoute);
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

                const SizedBox(height: 32),

                const Text(
                  'Searching for device...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animationController.value * 2 * 3.14159,
                      child: Image.asset(
                        'assets/images/ic_loading_circle_1.png',
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuarterCircleSpinnerPainter extends CustomPainter {
  final double progress;

  QuarterCircleSpinnerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -3 * 3.14159 / 4;
    final sweepAngle = 3.14159 / 2;

    final animatedSweepAngle = sweepAngle * progress;
    
    canvas.drawArc(
      rect,
      startAngle,
      animatedSweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(QuarterCircleSpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 