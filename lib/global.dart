import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dice_set.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:flutter/material.dart';

/// The `Globals` class is an inherited widget that provides access to global variables such as
/// `diceSets` and `dictionaries`.
class Globals extends InheritedWidget {
  static final Map<LangCode, DiceSet> diceSets = {
    LangCode.FR: DiceSet(dices: [
      ["E", "T", "U", "K", "N", "O"],
      ["E", "V", "G", "T", "I", "N"],
      ["D", "E", "C", "A", "M", "P"],
      ["I", "E", "L", "R", "U", "W"],
      ["E", "H", "I", "F", "S", "E"],
      ["R", "E", "C", "A", "L", "S"],
      ["E", "N", "T", "D", "O", "S"],
      ["O", "F", "X", "R", "I", "A"],
      ["N", "A", "V", "E", "D", "Z"],
      ["E", "I", "O", "A", "T", "A"],
      ["G", "L", "E", "N", "Y", "U"],
      ["B", "M", "A", "Q", "J", "O"],
      ["T", "L", "I", "B", "R", "A"],
      ["S", "P", "U", "L", "T", "E"],
      ["A", "I", "M", "S", "O", "R"],
      ["E", "N", "H", "R", "I", "S"]
    ])
  };

  static final Map<LangCode, Dictionary> dictionaries = {
    LangCode.FR: Dictionary(
        path: 'assets/dictionary/global.json',
        decoder: Decoded(lang: generateLangCode()))
  };

  const Globals({
    super.key,
    required super.child,
  });

  static Globals? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Globals>();

  Dictionary selectDictionary(LangCode lang) {
    return dictionaries[lang]!;
  }

  DiceSet selectDiceSet(LangCode lang) {
    return diceSets[lang]!;
  }

  @override
  bool updateShouldNotify(Globals oldWidget) => false;
}
