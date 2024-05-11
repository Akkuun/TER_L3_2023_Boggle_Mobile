import 'package:bouggr/components/global/popup.dart';
import 'package:bouggr/utils/get_all_word.dart';

import 'package:flutter/material.dart';

class EndGameService extends ChangeNotifier with TriggerPopUp {
  Word? selectedWord;

  void setSelectedWord(Word word) {
    selectedWord = word;
    notifyListeners();
  }

  void resetSelectedWord() {
    selectedWord = null;
    notifyListeners();
  }

  void showPopUp() {
    super.toggle(true);
  }

  void hidePopUp() {
    super.toggle(false);
  }
}
