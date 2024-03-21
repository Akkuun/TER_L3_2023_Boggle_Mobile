import 'dart:convert';
import 'package:bouggr/utils/game_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bouggr/utils/decode.dart';

class GameDataStorage {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static const _key = 'gameResults';

  // Fonction pour sauvegarder la langue sélectionnée
  static Future<void> saveLanguage(LangCode language) async {
    final prefs = await SharedPreferences.getInstance();
    final langIndex = language.index;
    await prefs.setInt('selectedLanguage', langIndex);
  }

  // Fonction pour charger la langue sélectionnée
  static Future<LangCode> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langIndex = prefs.getInt('selectedLanguage');
    return langIndex != null
        ? LangCode.values[langIndex]
        : LangCode.FR; // Langue par défaut
  }

  // Méthode pour sauvegarder les résultats du jeu
  static Future<void> saveGameResult(GameResult gameResult) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> gameResults = prefs.getStringList(_key) ?? [];
    if (_auth.currentUser != null) {
      final user = _auth.currentUser;
      final userDoc = _db.collection('user_solo_games').doc(user!.uid);
      userDoc.set({'uid': user.uid, 'email': user.email});
      final userResults = userDoc.collection('gameResults');
      await userResults.add(gameResult.toJsonOnline());
      gameResult.uID = user.uid;
    }

    gameResults.add(jsonEncode(gameResult.toJsonLocal()));
    await prefs.setStringList(_key, gameResults);
  }

  // Méthode pour récupérer la liste des résultats de jeu stockés à partir des préférences partagées
  static Future<List<String>> loadGameResults() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? jsonList = prefs.getStringList(
        _key); // convertit les resultats en une liste dobjets GameResult
    if (jsonList == null) {
      return [];
    }

    return jsonList;
  }

  static Future<void> deleteGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
