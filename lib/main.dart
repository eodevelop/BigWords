import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/service/dependency_injection.dart';
import 'core/service/permission_service.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/permission_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await setupDependencyInjection();
  
  runApp(const ProviderScope(child: BigWordsApp()));
}

class BigWordsApp extends ConsumerWidget {
  const BigWordsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Big Words Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LauncherInitializer(),
    );
  }
}

class LauncherInitializer extends StatefulWidget {
  const LauncherInitializer({super.key});

  @override
  State<LauncherInitializer> createState() => _LauncherInitializerState();
}

class _LauncherInitializerState extends State<LauncherInitializer> {
  bool _isCheckingPermissions = true;
  bool _needsPermissionSetup = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }
  
  Future<void> _checkPermissions() async {
    final permissionService = getIt<PermissionService>();
    
    final overlayGranted = await permissionService.checkOverlayPermission();
    final batteryGranted = await permissionService.checkBatteryOptimization();
    
    setState(() {
      _isCheckingPermissions = false;
      _needsPermissionSetup = !overlayGranted || !batteryGranted;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermissions) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_needsPermissionSetup) {
      return const PermissionSetupScreen();
    }
    
    return const HomeScreen();
  }
}