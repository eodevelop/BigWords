import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final iconCache = ref.watch(appIconCacheProvider);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAppIcon(context, ref, settings, iconCache),
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
  
  Widget _buildAppIcon(BuildContext context, WidgetRef ref, LauncherSettings settings, Map<String, Uint8List> iconCache) {
    final cachedIcon = iconCache[appInfo.packageName];
    
    if (cachedIcon != null) {
      return _buildIconImageFromCache(cachedIcon, settings);
    }
    
    final installedAppsAsync = ref.watch(installedAppsProvider);
    
    return installedAppsAsync.when(
      data: (installedApps) {
        try {
          final foundApp = installedApps.firstWhere(
            (app) => app.packageName == appInfo.packageName,
          );
          
          if (foundApp.icon != null && foundApp.icon!.isNotEmpty) {
            Future.microtask(() async {
              await ref.read(appIconCacheProvider.notifier).cacheApp(foundApp);
            });
            
            return _buildIconImageFromList(foundApp.icon!, settings);
          } else {
            return _buildDefaultIcon(settings);
          }
        } catch (e) {
          return _buildDefaultIcon(settings);
        }
      },
      loading: () => _buildLoadingIcon(settings),
      error: (_, __) => _buildDefaultIcon(settings),
    );
  }
  
  Widget _buildIconImageFromList(List<int> iconData, LauncherSettings settings) {
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
          Uint8List.fromList(iconData),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(settings),
        ),
      ),
    );
  }
  
  Widget _buildLoadingIcon(LauncherSettings settings) {
    return Container(
      width: settings.iconSize,
      height: settings.iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: settings.isDarkMode ? Colors.grey[800] : Colors.grey[200],
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
  
  Widget _buildIconImageFromCache(Uint8List iconData, LauncherSettings settings) {
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
          iconData,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(settings),
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