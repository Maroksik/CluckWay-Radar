import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/storage_service.dart';
import 'utils/notification_service.dart';
import 'utils/bluetooth_service.dart';
import 'providers/app_providers.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('app_state');
  
  await StorageService.initialize();
  await NotificationService.initialize();
  await BluetoothService.initialize();
  
  runApp(const ProviderScope(child: CluckWayApp()));
}

class CluckWayApp extends ConsumerWidget {
  const CluckWayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'CluckWay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      routerConfig: router,
      builder: (context, child) {
        return Navigator(
          key: rootNavigatorKey,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => child!,
              settings: settings,
            );
          },
        );
      },
    );
  }
}
