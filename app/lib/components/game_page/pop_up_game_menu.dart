//components

import 'dart:math';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/popup.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/game_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpGameMenu extends StatelessWidget {
  const PopUpGameMenu({super.key});

  /// Count the number of words found by length in the current game
  List<int> _countWordsByLength(GameServices gameServices) {
    if (gameServices.words.isEmpty) {
      return [];
    }
    int max =
        gameServices.words.map((e) => e.length).reduce((a, b) => a > b ? a : b);
    List<int> count = List.filled(max - 2, 0);
    for (var word in gameServices.words) {
      count[word.length - 3]++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // is in listen: false because we don't need to get the update from the navigation action
    NavigationServices navigationServices =
        Provider.of<NavigationServices>(context, listen: false);

    // is in listen: true because we need to update the score
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: true);
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    GameResult gameResult = GameResult(
        score: gameServices.score,
        grid: gameServices.letters.join(),
        words: _countWordsByLength(gameServices));

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return PopUp<GameServices>(
      child: Positioned(
        top: h * 0.5 - min(w * 0.8, h * 0.8),
        left: min(w * 0.1, h * 0.1),
        child: Center(
          child: Container(
            height: min(w * 0.8, h * 0.8),
            width: min(w * 0.8, h * 0.8),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 181, 224, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BtnBoggle(
                  onPressed: () {
                    gameServices.toggle(false);
                    timerServices.start();
                  },
                  text: "X",
                  btnType: BtnType.square,
                ),
                const Text("Game Paused", style: TextStyle(fontSize: 30)),
                Text("${gameServices.score} points",
                    style: const TextStyle(fontSize: 20)),
                BtnBoggle(
                  onPressed: () {
                    gameServices.stop();

                    GameDataStorage.saveGameResult(gameResult);

                    timerServices.resetProgress();
                    gameServices.reset();
                    navigationServices.goToPage(PageName.home);
                  },
                  text: "new game",
                ),
                BtnBoggle(
                    onPressed: () {
                      gameServices.stop();

                      GameDataStorage.saveGameResult(gameResult);
                      gameServices.reset();
                      timerServices.resetProgress();
                      navigationServices.goToPage(PageName.home);
                    },
                    text: "Home",
                    btnType: BtnType.secondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
