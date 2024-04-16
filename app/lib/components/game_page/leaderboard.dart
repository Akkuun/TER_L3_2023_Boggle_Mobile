import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/global.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({
    super.key,
    this.rang,
  });

  final int? rang;

  @override
  Widget build(BuildContext context) {
    final GameServices gameServices = Provider.of<GameServices>(context);

    return const SizedBox();/*Column(
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
        ]
    );*/
  }
}
