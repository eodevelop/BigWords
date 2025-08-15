import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../data/models/app_info.dart';
import '../../data/models/launcher_settings.dart';

class AppIconWidget extends ConsumerStatefulWidget {
  final AppInfo appInfo;
  final VoidCallback onTap;

  const AppIconWidget({super.key, required this.appInfo, required this.onTap});

  @override
  ConsumerState<AppIconWidget> createState() => _AppIconWidgetState();
}

class _AppIconWidgetState extends ConsumerState<AppIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final iconCache = ref.watch(appIconCacheProvider);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder:
            (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient:
                      _isPressed
                          ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors:
                                settings.isDarkMode
                                    ? [
                                      Colors.grey[850]!.withValues(alpha: 0.5),
                                      Colors.grey[900]!.withValues(alpha: 0.5),
                                    ]
                                    : [
                                      Colors.grey[100]!.withValues(alpha: 0.5),
                                      Colors.grey[200]!.withValues(alpha: 0.5),
                                    ],
                          )
                          : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _isPressed ? 2 : 0,
                      sigmaY: _isPressed ? 2 : 0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            settings.isDarkMode
                                ? Colors.grey[900]!.withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.3),
                        border: Border.all(
                          color:
                              settings.isDarkMode
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAppIcon(context, ref, settings, iconCache),
                          const SizedBox(height: 12),
                          Text(
                            widget.appInfo.appName,
                            style: TextStyle(
                              fontSize: settings.fontSize * 0.8,
                              fontWeight: FontWeight.w600,
                              color:
                                  settings.isDarkMode
                                      ? Colors.white.withValues(alpha: 0.95)
                                      : Colors.black.withValues(alpha: 0.9),
                              shadows: [
                                Shadow(
                                  color:
                                      settings.isDarkMode
                                          ? Colors.black.withValues(alpha: 0.3)
                                          : Colors.white.withValues(alpha: 0.8),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildAppIcon(
    BuildContext context,
    WidgetRef ref,
    LauncherSettings settings,
    Map<String, Uint8List> iconCache,
  ) {
    final cachedIcon = iconCache[widget.appInfo.packageName];

    if (cachedIcon != null) {
      return _buildIconImageFromCache(cachedIcon, settings);
    }

    final installedAppsAsync = ref.watch(installedAppsProvider);

    return installedAppsAsync.when(
      data: (installedApps) {
        try {
          final foundApp = installedApps.firstWhere(
            (app) => app.packageName == widget.appInfo.packageName,
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

  Widget _buildIconImageFromList(
    List<int> iconData,
    LauncherSettings settings,
  ) {
    return Container(
      width: settings.iconSize * 1.15,
      height: settings.iconSize * 1.15,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
            ),
          ),
          child: Image.memory(
            Uint8List.fromList(iconData),
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => _buildDefaultIcon(settings),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIcon(LauncherSettings settings) {
    return Container(
      width: settings.iconSize * 1.15,
      height: settings.iconSize * 1.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              settings.isDarkMode
                  ? [Colors.grey[800]!, Colors.grey[850]!]
                  : [Colors.grey[200]!, Colors.grey[300]!],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              settings.isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconImageFromCache(
    Uint8List iconData,
    LauncherSettings settings,
  ) {
    return Container(
      width: settings.iconSize * 1.15,
      height: settings.iconSize * 1.15,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
            ),
          ),
          child: Image.memory(
            iconData,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => _buildDefaultIcon(settings),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(LauncherSettings settings) {
    return Container(
      width: settings.iconSize * 1.15,
      height: settings.iconSize * 1.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              settings.isDarkMode
                  ? [Colors.grey[700]!, Colors.grey[800]!]
                  : [Colors.grey[300]!, Colors.grey[400]!],
        ),
      ),
      child: Icon(
        Icons.apps,
        size: settings.iconSize * 0.7,
        color:
            settings.isDarkMode
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.black.withValues(alpha: 0.6),
      ),
    );
  }
}
