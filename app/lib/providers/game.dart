import 'package:bouggr/components/popup.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:flutter/material.dart';

enum GameType { solo, multi }

class GameServices extends ChangeNotifier with TriggerPopUp {
  LangCode? _lang;
  final List<String> _words = [];
  PlayerLeaderboard playerLeaderboard = PlayerLeaderboard();

  int _score = 0;
  GameType? _gameType;
  Map<String, dynamic> _multiResult = {};
  int _strikes = 0;
  List<String>? _letters;
  String? _longestWord;
  Coord? _tipsIndex;

  // Recuper la langue à partir des shared preferences
  Future<void> _initLanguage() async {
    _lang = await GameDataStorage.loadLanguage();
    notifyListeners();
  }

  GameServices() {
    _initLanguage();
  }

  // Récupère la langue actuelle
  LangCode get language {
    return _lang ?? LangCode.FR;
  }

  // Definit la langue actuelle
  void setLanguage(LangCode lang) {
    _lang = lang;
    GameDataStorage.saveLanguage(lang);
    notifyListeners();
  }

  String get longestWord {
    return _longestWord ?? '';
  }

  List<String> get letters {
    return _letters!;
  }

  set letters(List<String> letters) {
    _letters = letters;
  }

  set gameType(GameType gameType) {
    _gameType = gameType;
  }

  GameType get gameType {
    return _gameType!;
  }

  set multiResult(Map<String, dynamic> result) {
    _multiResult = result;
  }

  Map<String, dynamic> get multiResult {
    return _multiResult;
  }

  void stop() {
    super.toggle(true);
  }

  bool start() {
    super.toggle(false);
    notifyListeners();
    return Globals.selectDictionary(language).dictionary != null;
  }

  int get score {
    return _score;
  }

  List<String> get words {
    return _words;
  }

  bool isInWordList(String word) {
    return _words.contains(word);
  }

  void addWord(String word) {
    if (_words.contains(word)) {
      return;
    }
    if (word.length > (_longestWord?.length ?? 0)) {
      _longestWord = word;
    }
    _words.add(word);
    notifyListeners();
  }

  void addScore(int score) {
    _score += score;
    notifyListeners();
  }

  void addStrike() {
    _strikes++;
    notifyListeners();
  }

  int get strikes {
    return _strikes;
  }

  Coord? get tipsIndex {
    return _tipsIndex;
  }

  void setTipsIndex(Coord index) {
    _tipsIndex = index;
    notifyListeners();
  }

  void reset() {
    _tipsIndex = null;
    _score = 0;
    _words.clear();
    _strikes = 0;
    notifyListeners();
  }
}
