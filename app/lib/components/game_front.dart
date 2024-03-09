//components

import 'package:bouggr/components/action_and_timer.dart';
import 'package:bouggr/components/grille.dart';
import 'package:bouggr/components/scoreboard.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/components/words_found.dart';
import 'package:flutter/material.dart';

class GameFront extends StatelessWidget {
  const GameFront({
    super.key,
    required this.letters,
    required this.endWordSelection,
    required this.isWordValid,
  });

  final List<String> letters;
  final bool Function(String word, List<(int, int)> indexes)? endWordSelection;
  final bool Function(String word) isWordValid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const AppTitle(fontSize: 56),
              const ScoreBoard(),
              BoggleGrille(
                letters: letters,
                //letters: snapshot.data!,
                onWordSelectionEnd:
                    endWordSelection ?? (word, indexes) => false,
                isWordValid: isWordValid,
              ),
              const WordsFound(),
              const ActionAndTimer(),
            ],
          ),
        ),
      ),
    );
  }
}
