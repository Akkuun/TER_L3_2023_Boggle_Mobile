import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';
import 'package:provider/provider.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (rang != null)
          GameStat(
            statName: 'Rang',
            statValue: rang.toString(),
          ),
        GameStat(
          statName: 'Score',
          statValue: gameServices.score.toString(),
        ),
        GameStat(
          statName: 'Strikes',
          statValue: 'x${gameServices.strikes}',
        ),
      ],
    );
  }
}
