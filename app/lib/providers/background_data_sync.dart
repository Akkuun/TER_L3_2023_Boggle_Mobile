import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BackgroundDataSync extends ChangeNotifier {
  StreamSubscription<List<ConnectivityResult>>? _listener;

  bool _isConnected = true;

  BackgroundDataSync() {
    _listener = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        if (!_isConnected) {
          // Do something
          _isConnected = true;
          notifyListeners();
        }
      } else {
        if (_isConnected) {
          // Do something
          _isConnected = false;
          notifyListeners();
        }
      }
    });
  }

  cancel() {
    _listener?.cancel();
  }

  bool get isConnected => _isConnected;
}
