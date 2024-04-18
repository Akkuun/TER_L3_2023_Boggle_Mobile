import 'package:bouggr/components/game_page/leaderboard_row.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({
    super.key,
    this.players,
  });

  final List<PlayerStats>? players;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            LeaderboardRow(rank: 1, score: players![0].score, name: players![0].name),
            if (players!.length >= 2) LeaderboardRow(rank: 2, score: players![1].score, name: players![1].name),
            if (players!.length >= 3) LeaderboardRow(rank: 3, score: players![2].score, name: players![2].name),
          ]
      ),
    );
  }
}
