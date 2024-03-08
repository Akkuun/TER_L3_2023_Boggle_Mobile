import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    this.rang,
    required this.score,
    required this.strikes,
  });

  final int? rang;
  final int score;
  final int strikes;

  @override
  Widget build(BuildContext context) {
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
            statValue: score.toString(),
        ),
        GameStat(
            statName: 'Strikes',
            statValue: 'x$strikes',
        ),
      ],
    );
  }
}
