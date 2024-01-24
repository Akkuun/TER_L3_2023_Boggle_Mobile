import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/grille.dart';
import 'package:bouggr/components/title.dart';
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
      isWordValid: isWordValid,
    );
  }

  bool isWordValid(String word) {
    if (word.length < 3) {
      return false;
    }
    return true; // TODO: vérifier validité mot
  }

  bool endWordSelection(String word) {
    if (previousWords.contains(word) || !isWordValid(word)) {
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
    return word.length; // TODO: calculer score d'un mot
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
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
            const AppTitle(fontSize: 56),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('rang'), // Rang placeholder
                Text(' score '), // Score placeholder
                Text('strike'), // Strike placeholder
              ],
            ),
            boggleGrille,
            SizedBox(
              height: 150,
              child: ListView(
                children: [
                  const Text('Mots selectionnés :'),
                  for (var word in previousWords)
                    Text(word),
                ],
              ),
            ),
            const Text('3:00'), // Timer placeholder
          ],
        ),
      ),
    );
  }
}
