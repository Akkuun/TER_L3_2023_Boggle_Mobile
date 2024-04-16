import 'dart:collection';

import 'package:flutter/material.dart';

class RealtimeGameProvider extends ChangeNotifier {
  HashMap<String, dynamic> _players = HashMap<String, dynamic>();

  void initListeners() {
    // Ici on va initialiser les listeners pour écouter les changements
    // dans la base de données
  }

  void _updatePlayers(HashMap<String, dynamic> players) {
    _players = players;
    notifyListeners();
  }

  bool _isUpdated(HashMap<String, dynamic> players) {
    for (var player in players.keys) {
      if (_players[player] == null) {
        return true;
      }
    }

    if (_players.length != players.length) {
      return true;
    }

    return false;
  }

  void _listenerEvent(dynamic event) {
    if (event is HashMap<String, dynamic>) {
      if (_isUpdated(event)) {
        _updatePlayers(event);
      }
    }
  }

  get players {
    return _players.entries.toList();
  }
}
