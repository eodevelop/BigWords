import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/service/dependency_injection.dart';
import '../../core/service/permission_service.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/launcher_settings.dart';
import '../../l10n/app_localizations.dart';

class PermissionSetupScreen extends ConsumerStatefulWidget {
  const PermissionSetupScreen({super.key});

  @override
  ConsumerState<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends ConsumerState<PermissionSetupScreen> {
  final PermissionService _permissionService = getIt<PermissionService>();
  bool _overlayPermissionGranted = false;
  bool _batteryOptimizationGranted = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }
  
  Future<void> _checkPermissions() async {
    final overlayGranted = await _permissionService.checkOverlayPermission();
    final batteryGranted = await _permissionService.checkBatteryOptimization();
    
    setState(() {
      _overlayPermissionGranted = overlayGranted;
      _batteryOptimizationGranted = batteryGranted;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    
    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.blue,
        title: Text(
          AppLocalizations.of(context).permissionSetup,
          style: TextStyle(fontSize: settings.fontSize),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            title: AppLocalizations.of(context).permissionRequired,
            description: AppLocalizations.of(context).permissionRequiredDescription,
            settings: settings,
          ),
          const SizedBox(height: 24),
          _buildPermissionCard(
            title: AppLocalizations.of(context).overlayPermission,
            description: AppLocalizations.of(context).overlayPermissionDescription,
            isGranted: _overlayPermissionGranted,
            onRequest: () async {
              await _permissionService.requestOverlayPermission();
              await _checkPermissions();
            },
            settings: settings,
          ),
          const SizedBox(height: 16),
          _buildPermissionCard(
            title: AppLocalizations.of(context).batteryOptimization,
            description: AppLocalizations.of(context).batteryOptimizationDescription,
            isGranted: _batteryOptimizationGranted,
            onRequest: () async {
              await _permissionService.requestBatteryOptimization();
              await _checkPermissions();
            },
            settings: settings,
          ),
          const SizedBox(height: 24),
          if (_overlayPermissionGranted && _batteryOptimizationGranted)
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: settings.isDarkMode ? Colors.blue : Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).complete,
                style: TextStyle(
                  fontSize: settings.fontSize * 0.8,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard({
    required String title,
    required String description,
    required LauncherSettings settings,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.blue[900] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: settings.isDarkMode ? Colors.blue[200] : Colors.blue[700],
                size: settings.fontSize,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: settings.fontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: settings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: settings.fontSize * 0.7,
              color: settings.isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPermissionCard({
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onRequest,
    required LauncherSettings settings,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGranted
              ? Colors.green
              : (settings.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: settings.fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                        color: settings.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: settings.fontSize * 0.6,
                        color: settings.isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isGranted ? Icons.check_circle : Icons.error_outline,
                color: isGranted ? Colors.green : Colors.orange,
                size: settings.fontSize * 1.5,
              ),
            ],
          ),
          if (!isGranted) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: settings.isDarkMode ? Colors.blue : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).setPermission,
                style: TextStyle(
                  fontSize: settings.fontSize * 0.7,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}