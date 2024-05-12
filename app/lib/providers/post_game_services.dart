import 'package:bouggr/components/global/popup.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:flutter/material.dart';

class PostGameServices extends ChangeNotifier with TriggerPopUp {
  String? _grid;
  Word? _selectedWord;

  void setFocusGrid(String grid) {
    _grid = grid;
    notifyListeners();
  }

  String? get grid => _grid;

  Word? get selectedWord => _selectedWord;

  void setSelectedWord(Word word) {
    _selectedWord = word;
    notifyListeners();
  }

  void resetSelectedWord() {
    _selectedWord = null;
    notifyListeners();
  }

  void resetGrid() {
    _grid = null;
    notifyListeners();
  }

  void showPopUp() {
    super.toggle(true);
  }

  void hidePopUp() {
    super.toggle(false);
  }
}
