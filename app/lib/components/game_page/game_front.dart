import 'package:bouggr/components/game_page/action_and_timer.dart';
import 'package:bouggr/components/game_page/grille.dart';
import 'package:bouggr/components/game_page/scoreboard.dart';
import 'package:bouggr/components/game_page/only_multi/leaderboard.dart';
import 'package:bouggr/components/global/title.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:flutter/material.dart';

class GameFront extends StatelessWidget {
  final bool isMulti;
  const GameFront({super.key, required this.isMulti});

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
            AppTitle(fontSize: isMulti ? 46 : 56),
            if (isMulti) const LeaderBoard(),
            const ScoreBoard(),
            const BoggleGrille(),
            const LiveGameInfoBuilder(),
            ActionAndTimer(isMulti: isMulti),
          ],
        ),
      ),
    );
  }
}
