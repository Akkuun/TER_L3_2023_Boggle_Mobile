import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';

enum GameType {
  solo,
  multi;
}

class GameServices extends ChangeNotifier {
  LangCode _lang = LangCode.FR;
  //List<String> _words = List<String>.empty();
  bool _canPlay = false;
  GameType _type = GameType.solo;

  bool get canPlay {
    return _canPlay;
  }

  LangCode get language {
    return _lang;
  }

  GameType get gameType {
    return _type;
  }

  void stop() {
    _canPlay = false;
    notifyListeners();
  }

  bool start(LangCode lang, GameType type) {
    _canPlay = true;
    _lang = lang;
    _type = type;
    notifyListeners();

    return true;
  }
}
