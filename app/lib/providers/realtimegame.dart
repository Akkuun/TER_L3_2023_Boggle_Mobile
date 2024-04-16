import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class RealtimeGameProvider extends ChangeNotifier {
  HashMap<String, dynamic> _players = HashMap<String, dynamic>();
  late DatabaseReference dbRef;
  void initListeners() {
    // Ici on va initialiser les listeners pour écouter les changements
    // dans la base de données
    dbRef = FirebaseDatabase.instance.ref('games/${Globals.gameCode}/players');
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("Data : $data");
      _updatePlayers(data);
    });
  }

  void onDispose() {
    dbRef.onDisconnect();
  }

  void _updatePlayers(players) {
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
