import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/grille.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late BoggleGrille boggleGrille;
  List<String> previousWords = [];
  int rows = 4;
  int cols = 4;
  int score = 0;
  int lastSelectedPosition = -1;

  @override
  void initState() {
    super.initState();
    List<List<String>> letters = [
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
    ];
    List<String> usedLetters = [];
    for (var row in letters) {
      usedLetters.add(row[Random().nextInt(row.length)]);
    }
    boggleGrille = BoggleGrille(
      letters: usedLetters,
      onWordSelectionEnd: endWordSelection,
    );
  }

  bool isWordValid(String word) {
    // throw UnimplementedError();
    return true; // TODO: vérifier validité mot
  }


  bool endWordSelection(String word) {
    if (!isWordValid(word)) {
      return false;
    }
    updateScore(wordScore(word));
    previousWords.add(word);
    return true;
  }

  int updateScore(int wordScore) {
    setState(() {
      score += wordScore;
    });
    return score;
  }

  int wordScore(String word) {
    return word.length; // TODO: calculer score
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var bg_blue = const Color.fromRGBO(19, 42, 64, 57);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            BtnBoggle(
              onPressed: () {
                appState.goToPage(PageName.home);
              },
              text: 'home',
            ),
            Text(
              'BOUGGR',
              style: TextStyle(
                color: Colors.black,
                fontSize: 42,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('rang'),
                Text(' score '),
                Text('strike'),
              ],
            ),
            boggleGrille,
            Text('mots sélectionnés : '),
            for (var word in previousWords)
              Text(' $word '),
            Text('3:00'),
          ],
        ),
      ),
    );
  }
}
