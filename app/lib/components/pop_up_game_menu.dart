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
  final List<int> words;
  final String grid;

  const PopUpGameMenu({super.key, required this.grid, required this.words});

  @override
  Widget build(BuildContext context) {
    NavigationServices navigationServices =
        Provider.of<NavigationServices>(context, listen: false);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);
    int score = context.read<GameServices>().score;
    var h = MediaQuery.of(context).size.height * 0.8;
    var w = MediaQuery.of(context).size.width * 0.8;
    return PopUp<GameServices>(
      child: Positioned(
        top: MediaQuery.of(context).size.height * 0.5 - min(w, h),
        left: min(MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1),
        child: Center(
          child: Container(
            height: min(w, h),
            width: min(w, h),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 181, 224, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BtnBoggle(
                  onPressed: () {
                    gameServices.toggle(false);
                    Provider.of<TimerServices>(context, listen: false).start();
                  },
                  text: "X",
                  btnType: BtnType.square,
                ),
                const Text("Game Paused", style: TextStyle(fontSize: 30)),
                Text("$score points", style: const TextStyle(fontSize: 20)),
                BtnBoggle(
                  onPressed: () {
                    gameServices.stop();
                    gameServices.reset();
                    GameResult gameResult =
                        GameResult(score: score, grid: grid, words: words);

                    GameDataStorage.saveGameResult(gameResult);

                    navigationServices.goToPage(PageName.home);
                  },
                  text: "new game",
                ),
                BtnBoggle(
                    onPressed: () {
                      gameServices.stop();

                      GameResult gameResult =
                          GameResult(score: score, grid: grid, words: words);
                      GameDataStorage.saveGameResult(gameResult);
                      gameServices.reset();
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
