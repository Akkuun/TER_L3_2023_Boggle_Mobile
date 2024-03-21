import 'package:bouggr/components/popup.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:flutter/material.dart';

enum GameType { solo, multi }

class GameServices extends ChangeNotifier with TriggerPopUp {
  LangCode _lang = LangCode.FR;
  final List<String> _words = [];

  int _score = 0;
  int _strikes = 0;
  List<String>? _letters;
  String? _longestWord;

  GameServices() {
    // Récupére la langue à partir shared preferences lors de l'initialisation
    _initLanguage();
  }

  // Recuper la langue à partir des shared preferences
  Future<void> _initLanguage() async {
    _lang = await GameDataStorage.loadLanguage();
    notifyListeners();
  }

  // Récupère la langue actuelle
  LangCode get language {
    return _lang;
  }

  // Definit la langue actuelle
  set language(LangCode lang) {
    _lang = lang;
    notifyListeners();
    GameDataStorage.saveLanguage(lang);
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

  void stop() {
    super.toggle(true);
  }

  bool start(LangCode lang) {
    super.toggle(false);
    _lang = lang;

    notifyListeners();

    return true;
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

  void reset() {
    _score = 0;
    _words.clear();
    _strikes = 0;
    notifyListeners();
  }
}
