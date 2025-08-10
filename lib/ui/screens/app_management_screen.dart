import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart' as installed;
import '../../core/providers/app_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/app_info.dart';
import '../../data/models/launcher_settings.dart';

class AppManagementScreen extends ConsumerStatefulWidget {
  const AppManagementScreen({super.key});

  @override
  ConsumerState<AppManagementScreen> createState() => _AppManagementScreenState();
}

class _AppManagementScreenState extends ConsumerState<AppManagementScreen> {
  late List<AppInfo> selectedApps;
  
  @override
  void initState() {
    super.initState();
    selectedApps = [];
  }
  
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currentApps = ref.watch(selectedAppsProvider);
    final installedApps = ref.watch(installedAppsProvider);
    
    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.blue,
        title: Text(
          '앱 관리',
          style: TextStyle(fontSize: settings.fontSize),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveChanges(context),
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: settings.fontSize * 0.7,
              ),
            ),
          ),
        ],
      ),
      body: currentApps.when(
        data: (apps) {
          if (selectedApps.isEmpty) {
            selectedApps = List.from(apps);
          }
          
          return installedApps.when(
            data: (allApps) => _buildAppLists(context, apps, allApps, settings),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: Text(
                '앱 목록을 불러올 수 없습니다',
                style: TextStyle(
                  fontSize: settings.fontSize,
                  color: settings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            '오류가 발생했습니다',
            style: TextStyle(
              fontSize: settings.fontSize,
              color: settings.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppLists(
    BuildContext context,
    List<AppInfo> currentApps,
    List<installed.AppInfo> allApps,
    LauncherSettings settings,
  ) {
    // 아이콘 캐시 업데이트
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appIconCacheProvider.notifier).cacheApps(allApps);
    });
    
    final availableApps = allApps.where((app) {
      return !selectedApps.any((selected) => selected.packageName == app.packageName);
    }).toList();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('메인 화면 앱', settings),
        const SizedBox(height: 8),
        _buildSelectedAppsList(settings),
        const SizedBox(height: 24),
        _buildSectionTitle('추가 가능한 앱', settings),
        const SizedBox(height: 8),
        _buildAvailableAppsList(availableApps, settings),
      ],
    );
  }
  
  Widget _buildSectionTitle(String title, LauncherSettings settings) {
    return Text(
      title,
      style: TextStyle(
        fontSize: settings.fontSize * 0.8,
        fontWeight: FontWeight.bold,
        color: settings.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
  
  Widget _buildSelectedAppsList(LauncherSettings settings) {
    final iconCache = ref.watch(appIconCacheProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: selectedApps.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  '선택된 앱이 없습니다',
                  style: TextStyle(
                    fontSize: settings.fontSize * 0.7,
                    color: settings.isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ),
            )
          : Column(
              children: selectedApps.map((app) {
                final iconData = iconCache[app.packageName];
                return _buildAppTile(
                  app: app,
                  isSelected: true,
                  settings: settings,
                  onTap: () {
                    setState(() {
                      selectedApps.removeWhere((a) => a.packageName == app.packageName);
                    });
                  },
                  applicationIcon: iconData,
                );
              }).toList(),
            ),
    );
  }
  
  Widget _buildAvailableAppsList(List<installed.AppInfo> apps, LauncherSettings settings) {
    return Container(
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: apps.map((app) {
          return _buildAppTile(
            app: AppInfo(
              packageName: app.packageName,
              appName: app.name,
              iconPath: null,
              position: selectedApps.length,
            ),
            isSelected: false,
            settings: settings,
            onTap: () {
              setState(() {
                selectedApps.add(AppInfo(
                  packageName: app.packageName,
                  appName: app.name,
                  iconPath: null,
                  position: selectedApps.length,
                ));
              });
            },
            applicationIcon: app.icon,
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildAppTile({
    required AppInfo app,
    required bool isSelected,
    required LauncherSettings settings,
    required VoidCallback onTap,
    Uint8List? applicationIcon,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: settings.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        child: applicationIcon != null && applicationIcon.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(applicationIcon, fit: BoxFit.cover),
              )
            : Icon(
                Icons.apps,
                color: settings.isDarkMode ? Colors.white54 : Colors.black54,
              ),
      ),
      title: Text(
        app.appName,
        style: TextStyle(
          fontSize: settings.fontSize * 0.7,
          color: settings.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      trailing: Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        size: settings.fontSize * 1.2,
        color: isSelected 
            ? (settings.isDarkMode ? Colors.blue : Colors.blue)
            : (settings.isDarkMode ? Colors.white54 : Colors.black54),
      ),
    );
  }
  
  void _saveChanges(BuildContext context) {
    ref.read(selectedAppsProvider.notifier).updateApps(selectedApps);
    Navigator.pop(context);
  }
}