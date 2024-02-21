import 'dart:math';

class DiceSet {
  List<List<String>> dices;

  DiceSet({required this.dices});

  List<String> roll() {
    List<String> usedLetters = [];
    for (var row in dices) {
      usedLetters.add(row[Random().nextInt(row.length)]);
    }
    return usedLetters;
  }
}
