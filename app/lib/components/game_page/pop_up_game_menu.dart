//components

import 'dart:math';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/popup.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/game_result.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/realtimegame.dart';
import '../../utils/background_music_player.dart';

BackgroundMusicPlayer backgroundMusicPlayer = BackgroundMusicPlayer.instance;

class PopUpGameMenu extends StatelessWidget {
  final String uid;
  final GameType gameType;

  const PopUpGameMenu({
    super.key,
    required this.gameType,
    this.uid = '',
  });

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
        top: h * 0.5 - min(w * 0.45, h * 0.45),
        left: min(w * 0.05, h * 0.05),
        child: Center(
          child: Container(
            height: min(w * 0.9, h * 0.9),
            width: min(w * 0.9, h * 0.9),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 181, 224, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconBtnBoggle(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          backgroundMusicPlayer.resume();
                          gameServices.toggle(false);
                          timerServices.start();
                        },
                        btnType: BtnType.secondary,
                        btnSize: BtnSize.small,
                      ),
                    ],
                  ),
                   Text(Globals.getText(gameServices.language, 24), style: const TextStyle(fontSize: 30)),
                  Text("${gameServices.score} ${Globals.getText(gameServices.language, 57)}",
                      style: const TextStyle(fontSize: 20)),
                  BtnBoggle(
                    onPressed: () {
                      gameServices.stop();
                      GameDataStorage.saveGameResult(gameResult);

                      timerServices.resetProgress();
                      gameServices.multiResult = Provider.of<RealtimeGameProvider>(context, listen: false).game;
                      Provider.of<RealtimeGameProvider>(context, listen: false).onDispose();
                      navigationServices.goToPage(PageName.detail);
                    },
                    text: Globals.getText(gameServices.language, 27),
                  ),
                  BtnBoggle(
                    onPressed: () {
                      gameServices.stop();

                      GameDataStorage.saveGameResult(gameResult);

                      timerServices.resetProgress();
                      gameServices.reset();

                      if (gameType == GameType.multi) {
                        Globals.resetMultiplayerData();
                        FirebaseFunctions.instance.httpsCallable('LeaveGame').call({"userId": uid,});
                      }
                      Provider.of<RealtimeGameProvider>(context, listen: false).onDispose();
                      navigationServices.goToPage(PageName.home);
                    },
                    text: Globals.getText(gameServices.language, 25),
                  ),
                  BtnBoggle(
                      onPressed: () {
                        gameServices.stop();

                        GameDataStorage.saveGameResult(gameResult);
                        gameServices.reset();
                        timerServices.resetProgress();

                        if (gameType == GameType.multi) {
                          Globals.resetMultiplayerData();
                          FirebaseFunctions.instance.httpsCallable('LeaveGame').call({"userId": uid,});
                        }
                        Provider.of<RealtimeGameProvider>(context, listen: false).onDispose();
                        navigationServices.goToPage(PageName.home);
                      },
                      text: Globals.getText(gameServices.language, 26),
                      btnType: BtnType.secondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
