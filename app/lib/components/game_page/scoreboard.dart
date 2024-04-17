import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/global.dart';

class ScoreBoard extends StatelessWidget {
  final GameType gameType;
  const ScoreBoard({
    super.key,
    this.rang,
    required this.gameType,
  });

  final int? rang;

  @override
  Widget build(BuildContext context) {
    final GameServices gameServices = Provider.of<GameServices>(context);
    final statHeight = gameType == GameType.multi ? 0.2 : 0.2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (gameType == GameType.multi && rang != null)
          GameStat(
            height: statHeight,
            statName: Globals.getText(gameServices.language, 18),
            statValue: rang.toString(),
          ),
        GameStat(
          height: statHeight,
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
