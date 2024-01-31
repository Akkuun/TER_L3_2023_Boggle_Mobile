import 'package:flutter/material.dart';

/// c'est un listener qui permet de changer de page
/// il est utilisé dans main.dart
/// il est écouté dans page1.dart et page2.dart
class TimerServices extends ChangeNotifier {
  var _running = false;

  int _seconds = 0;
  int _minutes = 3;

  bool get isRunning {
    return _running;
  }

  int get minutes {
    return _minutes;
  }

  int get seconds {
    return _seconds;
  }

  void update(int seconds, int minutes) {
    _seconds = seconds;
    _minutes = minutes;
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
}
