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
  bool canScrollUp = false;
  bool canScrollDown = false;
  late AnimationController floatingController;
  late AnimationController fadeController;
  late Animation<double> floatingAnimation;
  late Animation<double> fadeAnimation;
  double scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateScrollStatus);

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

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollStatus();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollStatus);
    floatingController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  void _updateScrollStatus() {
    if (!mounted) return;

    final bool newCanScrollUp =
        widget.scrollController.hasClients &&
        widget.scrollController.position.pixels > 0;
    final bool newCanScrollDown =
        widget.scrollController.hasClients &&
        widget.scrollController.position.pixels <
            widget.scrollController.position.maxScrollExtent;

    final double newScrollProgress =
        widget.scrollController.hasClients &&
                widget.scrollController.position.maxScrollExtent > 0
            ? widget.scrollController.position.pixels /
                widget.scrollController.position.maxScrollExtent
            : 0.0;

    if (newCanScrollUp != canScrollUp ||
        newCanScrollDown != canScrollDown ||
        (newScrollProgress - scrollProgress).abs() > 0.01) {
      setState(() {
        canScrollUp = newCanScrollUp;
        canScrollDown = newCanScrollDown;
        scrollProgress = newScrollProgress;
      });

      if (canScrollUp || canScrollDown) {
        fadeController.forward();
      } else {
        fadeController.reverse();
      }
    }
  }

  void _scrollUp() {
    if (!widget.scrollController.hasClients) return;

    final double currentPosition = widget.scrollController.position.pixels;
    final double targetPosition = (currentPosition - 300).clamp(
      widget.scrollController.position.minScrollExtent,
      widget.scrollController.position.maxScrollExtent,
    );

    widget.scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollDown() {
    if (!widget.scrollController.hasClients) return;

    final double currentPosition = widget.scrollController.position.pixels;
    final double targetPosition = (currentPosition + 300).clamp(
      widget.scrollController.position.minScrollExtent,
      widget.scrollController.position.maxScrollExtent,
    );

    widget.scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (canScrollUp || canScrollDown)
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: _buildModernScrollBar(),
              ),
            ),
          ),
        if (canScrollUp)
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: _buildFloatingButton(
                icon: Icons.keyboard_arrow_up_rounded,
                onTap: _scrollUp,
                isTop: true,
              ),
            ),
          ),
        if (canScrollDown)
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: _buildFloatingButton(
                icon: Icons.keyboard_arrow_down_rounded,
                onTap: _scrollDown,
                isTop: false,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModernScrollBar() {
    return Container(
      width: 4,
      height: 100,
      decoration: BoxDecoration(
        color: (widget.settings.isDarkMode ? Colors.white : Colors.black)
            .withValues(alpha: 0.1),
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      widget.settings.isDarkMode
                          ? [Colors.blue.shade300, Colors.purple.shade300]
                          : [Colors.blue.shade600, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: (widget.settings.isDarkMode
                            ? Colors.blue
                            : Colors.purple)
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
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isTop,
  }) {
    return AnimatedBuilder(
      animation: floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, floatingAnimation.value),
          child: Center(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isTop) _buildGradientLine(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              begin:
                                  isTop
                                      ? Alignment.topCenter
                                      : Alignment.bottomCenter,
                              end:
                                  isTop
                                      ? Alignment.bottomCenter
                                      : Alignment.topCenter,
                              colors:
                                  widget.settings.isDarkMode
                                      ? [
                                        Colors.blue.shade300,
                                        Colors.purple.shade300,
                                      ]
                                      : [
                                        Colors.blue.shade600,
                                        Colors.purple.shade600,
                                      ],
                            ).createShader(bounds),
                        child: Icon(icon, size: 48, color: Colors.white),
                      ),
                    ),
                    if (!isTop) _buildGradientLine(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientLine() {
    return Container(
      width: 60,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            widget.settings.isDarkMode
                ? Colors.blue.shade300.withValues(alpha: 0.8)
                : Colors.blue.shade600.withValues(alpha: 0.8),
            widget.settings.isDarkMode
                ? Colors.purple.shade300.withValues(alpha: 0.8)
                : Colors.purple.shade600.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
