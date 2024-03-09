import 'package:bouggr/components/popup.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';

enum GameType {
  solo,
  multi;
}

class GameServices extends ChangeNotifier with TriggerPopUp {
  LangCode _lang = LangCode.FR;
  List<String> _words = List<String>.empty(growable: true);
  GameType type = GameType.solo;
  int _score = 0;
  int _strikes = 0;

  GameServices({
    this.type = GameType.solo,
  });

  LangCode get language {
    return _lang;
  }

  GameType get gameType {
    return type;
  }

  void stop() {
    super.toggle(true);
  }

  bool start(LangCode lang, GameType type) {
    super.toggle(false);
    _lang = lang;
    type = type;
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
