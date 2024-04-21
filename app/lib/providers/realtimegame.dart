import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RealtimeGameProvider extends ChangeNotifier {
  dynamic _game = HashMap<String, dynamic>();
  String _lastGameCode = "";
  DatabaseReference? dbRef;
  String _gameCode = '';
  final logger = Logger();
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
    dbRef!.onValue.listen((DatabaseEvent event) {
      final data =
          HashMap<String, dynamic>.from(event.snapshot.value as Map? ?? {});
      logger.d("[PROVIDER] Data of game : $data");
      if (_lastGameCode == _gameCode) {
        return;
      }
      _updateGame(Map<String, dynamic>.from(data));
    });
  }

  Future<void> onDispose() async {
    if (dbRef == null) {
      return;
    }
    logger.d("[PROVIDER] Disposing of the game");

    await dbRef!.onValue.listen((DatabaseEvent event) {}).cancel();
    _lastGameCode = _gameCode;
    gameCode = '';
    _game = HashMap<String, dynamic>();
    dbRef!.onDisconnect();
    logger.d("[PROVIDER] game disposed");
  }

  void _updateGame(game) {
    logger.d("[PROVIDER] Updating game to $game");
    _game = game;
    notifyListeners();
  }

  get game {
    return _game;
  }
}
