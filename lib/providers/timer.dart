import 'package:flutter/material.dart';

/// c'est un listener qui permet de changer de page
/// il est utilisé dans main.dart
/// il est écouté dans page1.dart et page2.dart
class TimerServices extends ChangeNotifier {
  var _running = false;

  int _seconds = 0;
  int _minutes = 3;

  double _progression = 1.0;

  bool get isRunning {
    return _running;
  }

  int get minutes {
    return _minutes;
  }

  int get seconds {
    return _seconds;
  }

  double get progression {
    return _progression;
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
    int totalSeconds = _minutes * 60 + _seconds;
    double progress = 1.0 - (totalSeconds / 180);
    print('Progression: $progress');
    return progress;
  }

  void resetProgress() {
    _progression = 1.0;
    notifyListeners();
  }
  void setprogression(double d) {
    _progression=d;
    notifyListeners();
  }
}
