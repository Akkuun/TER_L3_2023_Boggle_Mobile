// ignore_for_file: prefer_const_constructors

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/grille.dart';
import 'package:bouggr/components/timer.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late BoggleGrille boggleGrille;
  List<String> previousWords = [];
  int score = 0;
  int strikes = 0;
  //String scoreText = 'Score: 0';
  int lastSelectedPosition = -1;
  late Dictionary dictionary;

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
    dictionary = Dictionary(
        path: 'assets/dictionary/global.json',
        decoder: Decoded(lang: generateLangCode()));
    dictionary.load();
  }

  bool isWordValid(String word) {
    if (word.length < 3) {
      return false;
    }
    return dictionary.contain(word);
  }

  bool endWordSelection(String word) {
    if (previousWords.contains(word) || !isWordValid(word)) {
      setState(() {
        strikes++;
      });
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
    int wordLength = word.length;
    if (wordLength == 3 || wordLength == 4) {
      return 1;
    } else if (wordLength == 5) {
      return 2;
    } else if (wordLength == 6) {
      return 3;
    } else if (wordLength == 7) {
      return 5;
    } else if (wordLength >= 8) {
      return 11;
    } else {
      return 0;
    }
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
            const Text(
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
                const Text(
                  'rang: 1',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                SizedBox(width: 50),
                Text(
                  'Score: $score',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(width: 50),
                Text(
                  'Strike: $strikes',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
            boggleGrille,
            const Text(
                'mots sélectionnés : '), // TODO : remplacer par le mot courant
            for (var word in previousWords) Text(' $word '),
            BoggleTimer(), // Timer placeholder
          ],
        ),
      ),
    );
  }
}
