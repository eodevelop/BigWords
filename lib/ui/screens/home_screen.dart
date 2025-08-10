import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/service/dependency_injection.dart';
import '../../core/service/app_service.dart';
import '../../data/models/app_info.dart';
import '../../data/models/launcher_settings.dart';
import '../widgets/app_icon_widget.dart';
import 'app_management_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApps = ref.watch(selectedAppsProvider);
    final settings = ref.watch(settingsProvider);
    
    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(context, ref, settings),
            Expanded(
              child: selectedApps.when(
                data: (apps) => _buildAppGrid(context, ref, apps, settings),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    '오류가 발생했습니다',
                    style: TextStyle(
                      fontSize: settings.fontSize,
                      color: settings.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomBar(context, ref, settings),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusBar(BuildContext context, WidgetRef ref, LauncherSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateTime.now().toString().split(' ')[0],
            style: TextStyle(
              fontSize: settings.fontSize * 0.7,
              color: settings.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Text(
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: settings.fontSize,
              fontWeight: FontWeight.bold,
              color: settings.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppGrid(BuildContext context, WidgetRef ref, List<AppInfo> apps, LauncherSettings settings) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: settings.gridColumns,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return AppIconWidget(
          appInfo: app,
          onTap: () => _launchApp(context, ref, app.packageName),
        );
      },
    );
  }
  
  Widget _buildBottomBar(BuildContext context, WidgetRef ref, LauncherSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomButton(
            context,
            icon: Icons.apps,
            label: '앱 관리',
            settings: settings,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppManagementScreen()),
            ),
          ),
          _buildBottomButton(
            context,
            icon: Icons.settings,
            label: '설정',
            settings: settings,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required LauncherSettings settings,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: settings.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: settings.iconSize * 0.5,
              color: settings.isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: settings.fontSize * 0.6,
                color: settings.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _launchApp(BuildContext context, WidgetRef ref, String packageName) async {
    final appService = getIt<AppService>();
    try {
      await appService.launchApp(packageName);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('앱을 실행할 수 없습니다: $packageName'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}