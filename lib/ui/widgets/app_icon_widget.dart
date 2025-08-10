import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart' as installed;
import '../../data/models/app_info.dart';
import '../../data/models/launcher_settings.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/app_provider.dart';

class AppIconWidget extends ConsumerWidget {
  final AppInfo appInfo;
  final VoidCallback onTap;
  
  const AppIconWidget({
    super.key,
    required this.appInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final installedApps = ref.watch(installedAppsProvider);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            installedApps.when(
              data: (apps) {
                installed.AppInfo? foundApp;
                try {
                  foundApp = apps.firstWhere(
                    (a) => a.packageName == appInfo.packageName,
                  );
                } catch (e) {
                  foundApp = null;
                }
                
                if (foundApp != null && foundApp.icon != null && foundApp.icon!.isNotEmpty) {
                  return Container(
                    width: settings.iconSize,
                    height: settings.iconSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: settings.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        foundApp.icon!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return _buildDefaultIcon(settings);
                }
              },
              loading: () => _buildDefaultIcon(settings),
              error: (_, __) => _buildDefaultIcon(settings),
            ),
            if (settings.showAppNames) ...[
              const SizedBox(height: 8),
              Text(
                appInfo.appName,
                style: TextStyle(
                  fontSize: settings.fontSize * 0.6,
                  color: settings.isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildDefaultIcon(LauncherSettings settings) {
    return Container(
      width: settings.iconSize,
      height: settings.iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: settings.isDarkMode ? Colors.grey[700] : Colors.grey[300],
      ),
      child: Icon(
        Icons.apps,
        size: settings.iconSize * 0.6,
        color: settings.isDarkMode ? Colors.white70 : Colors.black54,
      ),
    );
  }
}