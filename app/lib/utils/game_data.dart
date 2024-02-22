import 'dart:convert';
import 'package:bouggr/utils/game_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameDataStorage {
  static const _key = 'gameResults';
  // methode pour sauvegarder les resultat du jeu
  static Future<void> saveGameResult(GameResult gameResult) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> gameResults = prefs.getStringList(_key) ?? [];
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
