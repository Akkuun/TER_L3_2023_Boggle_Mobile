import 'package:bouggr/components/grille.dart';

import 'package:bouggr/components/scoreboard.dart';
import 'package:bouggr/components/words_found.dart';
import 'package:bouggr/components/title.dart';

//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';

//utils
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/word_score.dart';
import 'package:bouggr/utils/dico.dart';
//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/action_and_timer.dart';
import '../components/pop_up_game_menu.dart';

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
  int lastSelectedPosition = -1;
  late Dictionary dictionary;

  @override
  void initState() {
    super.initState();
    var lang = Provider.of<GameServices>(context, listen: false).language;

    dictionary = Globals.selectDictionary(lang);
    dictionary.load();
    List<String> selectedLetter = Globals.selectDiceSet(lang).roll();

    boggleGrille = BoggleGrille(
        letters: selectedLetter,
        onWordSelectionEnd: endWordSelection,
        isWordValid: isWordValid);
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

  @override
  Widget build(BuildContext context) {
    var timerServices = context.watch<TimerServices>();
    var gameServices = context.watch<GameServices>();
    return Globals(child: Builder(builder: (BuildContext innerContext) {
      // Calculer l'opacité en fonction de la progression
      double opacity =  timerServices.progression;

      return Stack(
        children: [
          // Fond de la page blanc avec une opacité réduite en fonction de la progression
          Container(
            color: Colors.red.withOpacity(opacity),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    const AppTitle(fontSize: 56),
                    ScoreBoard(score: score, strikes: strikes),
                    boggleGrille,
                    WordsFound(previousWords: previousWords),
                    ActionAndTimer(gameServices: gameServices),
                    Text(timerServices.seconds.toString()),
                    Text(gameServices.triggerPopUp.toString())
                  ],
                ),
              ),
            ),
          ),
          const PopUpGameMenu(),
        ],
      );
    }));
  }
}

