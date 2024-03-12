import 'package:bouggr/components/popup.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';

enum GameType {
  solo,
  multi;
}

class GameServices extends ChangeNotifier with TriggerPopUp {
  LangCode _lang = LangCode.FR;
  final List<String> _words = List<String>.empty(growable: true);

  int _score = 0;
  int _strikes = 0;
  List<String>? _letters;
  String? _longestWord;

  GameServices();

  LangCode get language {
    return _lang;
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
    if (word.length > _longestWord!.length) {
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
