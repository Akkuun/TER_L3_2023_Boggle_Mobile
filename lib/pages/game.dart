//components
import 'dart:math';

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/grille.dart';
import 'package:bouggr/components/popup.dart';
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
    var gameServices = context.watch<GameServices>();
    return Globals(child: Builder(builder: (BuildContext innerContext) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  const AppTitle(fontSize: 56),
                  ScoreBoard(score: score, strikes: strikes),
                  boggleGrille,
                  WordsFound(previousWords: previousWords),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconBtnBoggle(
                        onPressed: () {
                          Provider.of<GameServices>(context, listen: false)
                              .toggle(!gameServices.triggerPopUp);
                        },
                        icon: Icon(
                          gameServices.triggerPopUp
                              ? Icons.play_arrow
                              : Icons.pause,
                          color: Colors.black,
                          size: 48,
                          semanticLabel: "pause",
                        ),
                      ),
                      const BoggleTimer(),
                      IconBtnBoggle(
                        onPressed: () {
                          Provider.of<GameServices>(context, listen: false)
                              .stop();
                        },
                        icon: const Icon(
                          Icons.pause,
                          color: Colors.black,
                          size: 48,
                          semanticLabel: "pause",
                        ),
                      ),
                    ],
                  ),
                  Text(timerServices.seconds.toString()),
                  Text(gameServices.triggerPopUp.toString())
                ],
              ),
            ),
          ),
          PopUp<GameServices>(
            child: Center(
              child: Container(
                height: min(MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.8),
                width: min(MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.8),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 181, 224, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    BtnBoggle(
                      onPressed: () {
                        Provider.of<GameServices>(context, listen: false)
                            .toggle(false);
                      },
                      text: "X",
                      btnType: BtnType.square,
                    ),
                    BtnBoggle(
                      onPressed: () {
                        Provider.of<GameServices>(context, listen: false)
                            .stop();
                        Provider.of<NavigationServices>(context, listen: false)
                            .goToPage(PageName.home);
                      },
                      text: "new game",
                    ),
                    BtnBoggle(
                        onPressed: () {
                          Provider.of<GameServices>(context, listen: false)
                              .stop();
                          Provider.of<NavigationServices>(context,
                                  listen: false)
                              .goToPage(PageName.home);
                        },
                        text: "Home",
                        btnType: BtnType.secondary),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }
}
