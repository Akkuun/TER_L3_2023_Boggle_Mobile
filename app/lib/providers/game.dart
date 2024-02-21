import 'package:bouggr/components/popup.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';

enum GameType {
  solo,
  multi;
}

class GameServices extends ChangeNotifier with TriggerPopUp {
  LangCode _lang = LangCode.FR;
  //List<String> _words = List<String>.empty();

  GameType _type = GameType.solo;

  LangCode get language {
    return _lang;
  }

  GameType get gameType {
    return _type;
  }

  void stop() {
    super.toggle(true);
  }

  bool start(LangCode lang, GameType type) {
    super.toggle(false);
    _lang = lang;
    _type = type;
    notifyListeners();

    return true;
  }
}
