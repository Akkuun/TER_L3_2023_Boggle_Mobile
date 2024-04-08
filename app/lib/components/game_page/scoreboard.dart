import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/global.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    this.rang,
  });

  final int? rang;

  @override
  Widget build(BuildContext context) {
    final GameServices gameServices = Provider.of<GameServices>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (rang != null)
          GameStat(
            statName: Globals.getText(gameServices.language, 18),
            statValue: rang.toString(),
          ),
        GameStat(
          statName: Globals.getText(gameServices.language, 20),
          statValue: gameServices.score.toString(),
        ),
        GameStat(
          statName: Globals.getText(gameServices.language, 19),
          statValue: 'x${gameServices.strikes}',
        ),
      ],
    );
  }
}
