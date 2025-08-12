import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/launcher_settings.dart';

class DateTimeDisplay extends StatefulWidget {
  final LauncherSettings settings;
  
  const DateTimeDisplay({
    super.key,
    required this.settings,
  });

  @override
  State<DateTimeDisplay> createState() => _DateTimeDisplayState();
}

class _DateTimeDisplayState extends State<DateTimeDisplay> {
  late Timer _timer;
  late DateTime _currentTime;
  
  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  String _getWeekdayInKorean(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }
  
  String _getPeriod() {
    final hour = _currentTime.hour;
    if (hour < 6) return '새벽';
    if (hour < 12) return '오전';
    if (hour < 18) return '오후';
    return '저녁';
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = widget.settings.isDarkMode;
    final baseSize = widget.settings.fontSize;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.blue.shade900, Colors.purple.shade900]
              : [Colors.blue.shade100, Colors.purple.shade100],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.blue : Colors.purple).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                color: isDark ? Colors.white70 : Colors.blue.shade700,
                size: baseSize,
              ),
              const SizedBox(width: 12),
              Text(
                '${_currentTime.year}년 ${_currentTime.month}월 ${_currentTime.day}일',
                style: TextStyle(
                  fontSize: baseSize * 0.9,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_getWeekdayInKorean(_currentTime.weekday)}요일',
                  style: TextStyle(
                    fontSize: baseSize * 0.8,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.amber.withValues(alpha: 0.3) 
                      : Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getPeriod(),
                  style: TextStyle(
                    fontSize: baseSize * 0.7,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.amber.shade200 : Colors.amber.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.access_time_filled,
                color: isDark ? Colors.white70 : Colors.purple.shade700,
                size: baseSize * 1.2,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('h:mm').format(_currentTime),
                style: TextStyle(
                  fontSize: baseSize * 1.8,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                ':${_currentTime.second.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: baseSize * 1.2,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _currentTime.hour < 12 ? 'AM' : 'PM',
                style: TextStyle(
                  fontSize: baseSize * 0.8,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}