import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RealtimeGameProvider extends ChangeNotifier {
  Map<String, dynamic> _game = {};

  DatabaseReference? dbRef;
  String _gameCode = '';
  final logger = Logger();
  String get gameCode {
    return _gameCode;
  }

  setGameCode(String code) {
    Logger().d("[PROVIDER] Setting game code to $code");
    _gameCode = code;
    notifyListeners();
  }

  void initListeners() {
    // Ici on va initialiser les listeners pour écouter les changements
    // dans la base de données

    dbRef = FirebaseDatabase.instance.ref('games/$_gameCode');
    dbRef!.onValue.listen((DatabaseEvent event) {
      final data =
          Map<String, dynamic>.from(event.snapshot.value as Map? ?? {});
      logger.d("[PROVIDER] Data of game : $data");

      _updateGame(Map<String, dynamic>.from(data));
    });
  }

  Future<void> onDispose() async {
    if (dbRef != null) {
      await dbRef!.onValue.listen((DatabaseEvent event) {}).cancel();
      dbRef!.onDisconnect();
    }
    _gameCode = '';
    _game.clear();
    dbRef = null;
    notifyListeners();
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

  void initRealtimeService(gameId) {
    _gameCode = gameId;
    _game = {};
    initListeners();
    notifyListeners();
  }
}
