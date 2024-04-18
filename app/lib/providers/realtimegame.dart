import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class RealtimeGameProvider extends ChangeNotifier {
  dynamic _players = HashMap<String, dynamic>();
  int _gameStatus = 3;
  late DatabaseReference dbRef;
  void initListeners() {
    // Ici on va initialiser les listeners pour écouter les changements
    // dans la base de données
    dbRef = FirebaseDatabase.instance.ref('games/${Globals.gameCode}');
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = HashMap<String,dynamic>.from (event.snapshot.value! as Map);
      print("Data QUE JE VEUX : ${data["players"]}");
      _updatePlayers(data["players"]);
      _updateGameStatus(data["status"]);
    });
  }

  void onDispose() {
    dbRef.onDisconnect();
  }

  void _updatePlayers(players) {
    _players = players;
    notifyListeners();
  }

  void _updateGameStatus(status) {
    _gameStatus = status;
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

  get gameStatus {
    return _gameStatus;
  }
}
