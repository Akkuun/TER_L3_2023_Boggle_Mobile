import 'package:bouggr/components/popup.dart';
import 'package:bouggr/utils/get_all_word.dart';

import 'package:flutter/material.dart';

class EndGameService extends ChangeNotifier with TriggerPopUp {
  Word? selectedWord;

  void setSelectedWord(Word word) {
    selectedWord = word;
    notifyListeners();
  }

  EndGameService();
}
