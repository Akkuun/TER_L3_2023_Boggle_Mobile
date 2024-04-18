import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/global.dart';

class ScoreBoard extends StatelessWidget {
  final GameType gameType;
  const ScoreBoard({
    super.key,
    this.rank,
    required this.gameType,
  });

  final int? rank;

  @override
  Widget build(BuildContext context) {
    final GameServices gameServices = Provider.of<GameServices>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (gameType == GameType.multi && rank != null)
          GameStat(
            orientation: (gameType == GameType.multi) ? Axis.horizontal : Axis.vertical,
            statName: Globals.getText(gameServices.language, 18),
            statValue: rank.toString(),
          ),
        GameStat(
          orientation: (gameType == GameType.multi) ? Axis.horizontal : Axis.vertical,
          statName: Globals.getText(gameServices.language, 20),
          statValue: gameServices.score.toString(),
        ),
        GameStat(
          orientation: (gameType == GameType.multi) ? Axis.horizontal : Axis.vertical,
          statName: Globals.getText(gameServices.language, 19),
          statValue: 'x${gameServices.strikes}',
        ),
      ],
    );
  }
}
