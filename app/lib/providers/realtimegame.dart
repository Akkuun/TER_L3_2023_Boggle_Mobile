import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealtimeGameProvider extends ChangeNotifier {
  dynamic _game = HashMap<String, dynamic>();
  String _lastGameCode = "";
  late DatabaseReference dbRef;
  String _gameCode = '';

  String get gameCode {
    return _gameCode;
  }

  set gameCode(String code) {
    _gameCode = code;
    notifyListeners();
  }

  void initListeners() {
    // Ici on va initialiser les listeners pour écouter les changements
    // dans la base de données
    dbRef = FirebaseDatabase.instance.ref('games/${_gameCode}');
    dbRef.onValue.listen((DatabaseEvent event) {
      final data = HashMap<String, dynamic>.from(event.snapshot.value! as Map);
      print("[PROVIDER] Data of game : ${data}");
      if (_lastGameCode == _gameCode) {
        return;
      }
      _updateGame(Map<String, dynamic>.from(data));
    });
  }

  void onDispose() {
    print("[PROVIDER] Disposing of the game");
    dbRef.onValue.listen((DatabaseEvent event) {}).cancel();
    _lastGameCode = _gameCode;
    gameCode = '';
    _game = HashMap<String, dynamic>();
    dbRef.onDisconnect();
  }

  void _updateGame(game) {
    print("[PROVIDER] Updating game to $game");
    _game = game;
    notifyListeners();
  }

  get game {
    return _game;
  }
}
