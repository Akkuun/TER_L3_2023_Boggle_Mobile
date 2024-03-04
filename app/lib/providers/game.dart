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
  GameType type = GameType.solo;

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
}
