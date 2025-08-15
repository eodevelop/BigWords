import 'package:flutter/material.dart';

import '../../data/models/launcher_settings.dart';

class ScrollIndicatorWidget extends StatefulWidget {
  final ScrollController scrollController;
  final LauncherSettings settings;
  final Widget child;

  const ScrollIndicatorWidget({
    super.key,
    required this.scrollController,
    required this.settings,
    required this.child,
  });

  @override
  State<ScrollIndicatorWidget> createState() => _ScrollIndicatorWidgetState();
}

class _ScrollIndicatorWidgetState extends State<ScrollIndicatorWidget>
    with TickerProviderStateMixin {
  static const _scrollDistance = 300.0;
  static const _animDuration = Duration(milliseconds: 400);

  bool canScrollUp = false;
  bool canScrollDown = false;
  double scrollProgress = 0.0;

  late final AnimationController floatingController;
  late final AnimationController fadeController;
  late final Animation<double> floatingAnimation;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    widget.scrollController.addListener(_updateScrollStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollStatus());
  }

  void _initAnimations() {
    floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: floatingController, curve: Curves.easeInOut),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollStatus);
    floatingController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  void _updateScrollStatus() {
    if (!mounted || !widget.scrollController.hasClients) return;

    final position = widget.scrollController.position;
    final newCanScrollUp = position.pixels > 0;
    final newCanScrollDown = position.pixels < position.maxScrollExtent;
    final newProgress =
        position.maxScrollExtent > 0
            ? position.pixels / position.maxScrollExtent
            : 0.0;

    if (newCanScrollUp != canScrollUp ||
        newCanScrollDown != canScrollDown ||
        (newProgress - scrollProgress).abs() > 0.01) {
      setState(() {
        canScrollUp = newCanScrollUp;
        canScrollDown = newCanScrollDown;
        scrollProgress = newProgress;
      });

      (canScrollUp || canScrollDown)
          ? fadeController.forward()
          : fadeController.reverse();
    }
  }

  void _scroll(double distance) {
    if (!widget.scrollController.hasClients) return;

    final position = widget.scrollController.position;
    widget.scrollController.animateTo(
      (position.pixels + distance).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: _animDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.settings.isDarkMode;

    return Stack(
      children: [
        widget.child,
        if (canScrollUp || canScrollDown) ...[
          _buildScrollBar(isDark),
          if (canScrollUp) _buildScrollButton(true, isDark),
          if (canScrollDown) _buildScrollButton(false, isDark),
        ],
      ],
    );
  }

  Widget _buildScrollBar(bool isDark) {
    return Positioned(
      right: 12,
      top: 0,
      bottom: 0,
      child: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            width: 4,
            height: 100,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  top: scrollProgress * 70,
                  child: Container(
                    width: 4,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: _getGradient(isDark, vertical: true),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? Colors.blue : Colors.purple)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollButton(bool isTop, bool isDark) {
    return Positioned(
      top: isTop ? 4 : null,
      bottom: isTop ? null : 4,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: AnimatedBuilder(
          animation: floatingAnimation,
          builder:
              (_, __) => Transform.translate(
                offset: Offset(0, floatingAnimation.value),
                child: Center(
                  child: GestureDetector(
                    onTap:
                        () =>
                            _scroll(isTop ? -_scrollDistance : _scrollDistance),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isTop) _buildGradientLine(isDark),
                          ShaderMask(
                            shaderCallback:
                                (bounds) => _getGradient(
                                  isDark,
                                  vertical: true,
                                  reverse: !isTop,
                                ).createShader(bounds),
                            child: Icon(
                              isTop
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                          if (!isTop) _buildGradientLine(isDark),
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

  Widget _buildGradientLine(bool isDark) {
    return Container(
      width: 60,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            (isDark ? Colors.blue.shade300 : Colors.blue.shade600).withValues(
              alpha: 0.8,
            ),
            (isDark ? Colors.purple.shade300 : Colors.purple.shade600)
                .withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  LinearGradient _getGradient(
    bool isDark, {
    bool vertical = false,
    bool reverse = false,
  }) {
    final colors =
        isDark
            ? [Colors.blue.shade300, Colors.purple.shade300]
            : [Colors.blue.shade600, Colors.purple.shade600];

    if (!vertical) return LinearGradient(colors: colors);

    return LinearGradient(
      begin: reverse ? Alignment.bottomCenter : Alignment.topCenter,
      end: reverse ? Alignment.topCenter : Alignment.bottomCenter,
      colors: colors,
    );
  }
}
