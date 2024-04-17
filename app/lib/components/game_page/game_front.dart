import 'package:bouggr/components/game_page/action_and_timer.dart';
import 'package:bouggr/components/game_page/grille.dart';
import 'package:bouggr/components/game_page/scoreboard.dart';
import 'package:bouggr/components/game_page/leaderboard.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/providers/game.dart';

class GameFront extends StatelessWidget {
  final GameType gameType;
  const GameFront({
    super.key,
    required this.gameType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppTitle(fontSize: 56),
            if (gameType == GameType.multi) const LeaderBoard(),
            ScoreBoard(gameType: gameType),
            BoggleGrille(gameType: gameType),
            const WordsFound(),
            const ActionAndTimer()
          ],
        ),
      ),
    );
  }
}
