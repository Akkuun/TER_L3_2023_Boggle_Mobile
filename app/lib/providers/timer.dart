import 'package:flutter/material.dart';

/// c'est un listener qui permet de changer de page
/// il est utilisé dans main.dart
/// il est écouté dans page1.dart et page2.dart
class TimerServices extends ChangeNotifier {
  var _running = false;

  int? _seconds;
  int? _minutes;

  double? _progression;

  bool get isRunning {
    return _running;
  }

  int get minutes {
    return _minutes ?? 0;
  }

  int get seconds {
    return _seconds ?? 0;
  }

  double get progression {
    return _progression ?? 0;
  }

  void update(int seconds, int minutes, double progression) {
    _seconds = seconds;
    _minutes = minutes;
    _progression = progression;
    notifyListeners();
  }

  void stop() {
    _running = false;
    notifyListeners();
  }

  void start() {
    _running = true;
    notifyListeners();
  }

  double getTimerProgress() {
    int totalSeconds = (_minutes ?? 3) * 60 + (_seconds ?? 0);
    _progression = 1.0 - (totalSeconds / 180);
    return _progression!;
  }

  void resetProgress() {
    _progression = 0;
    _seconds = 0;
    _minutes = 3;
  }

  void setprogression(double d) {
    _progression = d;
    notifyListeners();
  }
}
