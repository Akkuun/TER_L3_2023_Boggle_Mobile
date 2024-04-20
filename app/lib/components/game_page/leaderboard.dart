import 'package:bouggr/components/game_page/leaderboard_row.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      const Color(0xFFFFD700), // gold
      const Color(0xFFC0C0C0), // silver
      const Color(0xFFFF7D1E), // bronze
    ];

    var gameServices = Provider.of<GameServices>(context);
    var gameType = gameServices.gameType;

    var game = Provider.of<RealtimeGameProvider>(context).game;
    var players = game['players'];
    if (gameType == GameType.multi) {
      if (players != null) {
        for (var player in players!.entries) {
          gameServices.playerLeaderboard
              .updatePlayer(player.key, player.value['score']);
        }
      }

      gameServices.playerLeaderboard.computeRank();

      players = gameServices.playerLeaderboard.players;
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LeaderboardRow(
                rank: 1,
                score: players![0].score,
                name: players![0].name,
                color: colors[0]),
            if (players!.length >= 2)
              LeaderboardRow(
                  rank: 2,
                  score: players![1].score,
                  name: players![1].name,
                  color: colors[1]),
            if (players!.length >= 3)
              LeaderboardRow(
                  rank: 3,
                  score: players![2].score,
                  name: players![2].name,
                  color: colors[2]),
          ]),
    );
  }
}
