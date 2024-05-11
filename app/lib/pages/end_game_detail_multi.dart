import 'package:bouggr/components/global/btn.dart';
import 'package:bouggr/components/game_page/only_multi/leaderboard.dart';
import 'package:bouggr/components/game_page/pop_up_word_list.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class EndGameDetailMulti extends StatelessWidget {
  const EndGameDetailMulti({super.key});

  @override
  Widget build(BuildContext context) {
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    NavigationServices navigationServices =
        Provider.of<NavigationServices>(context, listen: false);

    EndGameService endGameService =
        Provider.of<EndGameService>(context, listen: true);

    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          color: const Color.fromARGB(255, 169, 224, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const MultiLeaderBoard(),
              const HeaderEndGameDetailMulti(),
              WordsFoundIngame(size: size),
              if (!endGameService.triggerPopUp)
                BtnBoggle(
                  onPressed: () {
                    endGameService.hidePopUp();
                    timerServices.resetProgress();
                    gameServices.reset();
                    navigationServices.goToPage(PageName.home);
                  },
                  text: Globals.getText(gameServices.language, 25),
                ),
              if (!endGameService.triggerPopUp)
                BtnBoggle(
                    onPressed: () {
                      endGameService.hidePopUp();
                      gameServices.reset();
                      timerServices.resetProgress();
                      navigationServices.goToPage(PageName.home);
                    },
                    text: Globals.getText(gameServices.language, 56),
                    btnType: BtnType.secondary),
            ],
          ),
        ),
        const PopUpWordList(),
      ],
    );
  }
}

class WordsFoundIngame extends StatelessWidget {
  const WordsFoundIngame({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            width: size.width * 0.9,
            child: const Padding(
                padding: EdgeInsets.all(8.0), child: WordsFound())),
      ),
    );
  }
}

class HeaderEndGameDetailMulti extends StatelessWidget {
  const HeaderEndGameDetailMulti({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final playerLeaderboard = PlayerLeaderboard();

    var size = MediaQuery.of(context).size;
    EndGameService endGameService =
        Provider.of<EndGameService>(context, listen: true);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: true);

    final players = gameServices.multiResult.isEmpty
        ? null
        : Map<String, dynamic>.from(gameServices.multiResult["players"])
            .entries
            .toList();
    if (players != null) {
      for (var player in players) {
        try {
          playerLeaderboard.addPlayer(
            PlayerStats(
                name: player.value['email'],
                score: player.value['score'],
                uid: player.key),
          );
        } catch (e) {
          Logger().e("Error while adding player to leaderboard : $e");
        }
      }
    }
    playerLeaderboard.computeRank();
    int rank = playerLeaderboard.getRank(
        Provider.of<FirebaseAuth>(context, listen: false).currentUser!.uid);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        width: size.width * 0.9,
        height: size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${Globals.getText(gameServices.language, 18)} $rank"),
                Text(
                    "${Globals.getText(gameServices.language, 61)} ${gameServices.score}"),
                Text(Globals.getText(gameServices.language, 62)),
              ],
            ),
            Text(
                "${Globals.getText(gameServices.language, 60)} ${gameServices.longestWord}"),
            Text(Globals.getText(gameServices.language, 59)),
            BtnBoggle(
              onPressed: () {
                endGameService.showPopUp();
              },
              text: Globals.getText(gameServices.language, 58),
              btnType: BtnType.third,
            ),
          ],
        ),
      ),
    );
  }
}

class MultiLeaderBoard extends StatelessWidget {
  const MultiLeaderBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          width: size.width * 0.9,
          child: const LeaderBoard()),
    );
  }
}
