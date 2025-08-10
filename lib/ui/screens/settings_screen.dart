import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/launcher_settings.dart';
import '../../l10n/app_localizations.dart';
import 'permission_setup_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    
    return Scaffold(
      backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.blue,
        title: Text(
          AppLocalizations.of(context).settings,
          style: TextStyle(fontSize: settings.fontSize),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(AppLocalizations.of(context).displaySettings, settings),
          const SizedBox(height: 16),
          _buildSliderTile(
            title: AppLocalizations.of(context).fontSize,
            value: settings.fontSize,
            min: 18,
            max: 36,
            divisions: 6,
            onChanged: (value) => settingsNotifier.updateFontSize(value),
            settings: settings,
          ),
          const SizedBox(height: 12),
          _buildSliderTile(
            title: AppLocalizations.of(context).iconSize,
            value: settings.iconSize,
            min: 60,
            max: 120,
            divisions: 6,
            onChanged: (value) => settingsNotifier.updateIconSize(value),
            settings: settings,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(AppLocalizations.of(context).themeSettings, settings),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: AppLocalizations.of(context).darkMode,
            value: settings.isDarkMode,
            onChanged: (_) => settingsNotifier.toggleDarkMode(),
            settings: settings,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(AppLocalizations.of(context).systemSettings, settings),
          const SizedBox(height: 16),
          _buildNavigationTile(
            title: AppLocalizations.of(context).permissionSettings,
            subtitle: AppLocalizations.of(context).permissionSettingsSubtitle,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PermissionSetupScreen()),
            ),
            settings: settings,
          ),
        ],
      ),
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
  
  Widget _buildSliderTile({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required LauncherSettings settings,
    bool isInt = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: settings.fontSize * 0.7,
                  color: settings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                isInt ? value.toInt().toString() : value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: settings.fontSize * 0.7,
                  fontWeight: FontWeight.bold,
                  color: settings.isDarkMode ? Colors.blue : Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              activeTrackColor: settings.isDarkMode ? Colors.blue : Colors.blue,
              inactiveTrackColor: settings.isDarkMode ? Colors.grey[700] : Colors.grey[300],
              thumbColor: settings.isDarkMode ? Colors.blue : Colors.blue,
              overlayColor: Colors.blue.withValues(alpha: 0.3),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required LauncherSettings settings,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: settings.fontSize * 0.7,
              color: settings.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required LauncherSettings settings,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: settings.fontSize * 0.7,
                      color: settings.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: settings.fontSize * 0.6,
                      color: settings.isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: settings.fontSize * 0.8,
              color: settings.isDarkMode ? Colors.white54 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}