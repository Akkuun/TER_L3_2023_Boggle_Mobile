import 'dart:convert';
import 'package:bouggr/utils/game_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameDataStorage {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static const _key = 'gameResults';
  // methode pour sauvegarder les resultat du jeu
  static Future<void> saveGameResult(GameResult gameResult) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> gameResults = prefs.getStringList(_key) ?? [];
    if (_auth.currentUser != null) {
      final user = _auth.currentUser;
      final userDoc = _db.collection('user_solo_games').doc(user!.uid);
      final userResults = userDoc.collection('gameResults');
      await userResults.add(gameResult.toJson());
    }

    gameResults.add(jsonEncode(gameResult.toJson()));
    await prefs.setStringList(_key, gameResults);
  }

  //methode pour recuperer la liste des resultats de jeu stockés à partir des preferences partagees
  static Future<List<GameResult>> loadGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(
        _key); // convertit les resultats en une liste dobjets GameResult
    if (jsonList == null) {
      return [];
    }
    return jsonList.map((jsonString) {
      return GameResult.fromJson(jsonDecode(jsonString));
    }).toList();
  }
}
