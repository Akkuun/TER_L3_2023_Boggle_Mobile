import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class RealtimeGameProvider extends ChangeNotifier {
  dynamic _game = HashMap<String, dynamic>();
  String _lastGameCode = "";
  late DatabaseReference dbRef;
  void initListeners() {
    // Ici on va initialiser les listeners pour écouter les changements
    // dans la base de données
    dbRef = FirebaseDatabase.instance.ref('games/${Globals.gameCode}');
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = HashMap<String,dynamic>.from (event.snapshot.value! as Map);
      print("[PROVIDER] Data of game : ${data}");
      if (_lastGameCode == Globals.gameCode) {
        return;
      }
      _updateGame(Map<String, dynamic>.from(data));
    });
  }

  void onDispose() {
    print("[PROVIDER] Disposing of the game");
    dbRef.onValue.listen((DatabaseEvent event) {}).cancel();
    _updateGame({"status": -1});
    _lastGameCode = Globals.gameCode;
    dbRef.onDisconnect();
  }

  void _updateGame(game) {
    print("[PROVIDER] Updating game to $game");
    _game = game;
    notifyListeners();
  }

  bool _isUpdated(HashMap<String, dynamic> data) {
    print("[PROVIDER] Checking if game is updated");
    print("[PROVIDER] Game : $_game");
    print("[PROVIDER] Data : $data\n-------------------\n");

    if (_game["status"] != data["status"]) {
      return true;
    }

    for (var player in data["players"].keys) {
      if (_game["players"][player] == null) {
        return true;
      }
    }

    if (_game["players"].length != data.length) {
      return true;
    }

    return true;
  }

  void _listenerEvent(dynamic event) {
    if (event is HashMap<String, dynamic>) {
      if (_isUpdated(event)) {
        _updateGame(event);
      }
    }
  }

  get game {
    return _game;
  }
}
