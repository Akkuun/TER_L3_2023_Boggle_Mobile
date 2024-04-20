import 'package:bouggr/components/game_page/action_and_timer.dart';
import 'package:bouggr/components/game_page/grille.dart';
import 'package:bouggr/components/game_page/scoreboard.dart';
import 'package:bouggr/components/game_page/leaderboard.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/providers/game.dart';

import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:provider/provider.dart';

class GameFront extends StatelessWidget {
  const GameFront({super.key});

  @override
  Widget build(BuildContext context) {
    final GameServices gameServices = Provider.of<GameServices>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTitle(
                fontSize: gameServices.gameType == GameType.multi ? 46 : 56),
            if (gameServices.gameType == GameType.multi) const LeaderBoard(),
            const ScoreBoard(),
            const BoggleGrille(),
            const WordsFound(),
            const ActionAndTimer()
          ],
        ),
      ),
    );
  }
}
