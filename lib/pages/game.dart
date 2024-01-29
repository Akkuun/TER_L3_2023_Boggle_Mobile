//components
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/grille.dart';
import 'package:bouggr/components/scoreboard.dart';
import 'package:bouggr/components/words_found.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/components/timer.dart';

//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';

//utils
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/word_score.dart';
import 'package:bouggr/utils/dico.dart';
//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Globals(child: Builder(builder: (BuildContext innerContext) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              BtnBoggle(
                onPressed: () {
                  Provider.of<GameServices>(context, listen: false).stop();
                  Provider.of<NavigationServices>(context, listen: false)
                      .goToPage(PageName.home);
                },
                text: 'home',
              ),

              const AppTitle(fontSize: 56),
              ScoreBoard(score: score, strikes: strikes),
              boggleGrille,
              WordsFound(previousWords: previousWords),
              const BoggleTimer(),
              Text(timerServices.seconds.toString()) // Timer placeholder
            ],
          ),
        ),
      );
    }));
  }
}
