import 'package:bouggr/components/game_page/only_multi/leaderboard_row.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatelessWidget {
  //only used in multiplayer mode
  const LeaderBoard({
    super.key,
  });

  static const List<Color> colors = [
    Color(0xFFFFD700), // gold
    Color(0xFFC0C0C0), // silver
    Color(0xFFFF7D1E), // bronze
  ];

  @override
  Widget build(BuildContext context) {
    var gameServices = Provider.of<GameServices>(context);

    var game = Provider.of<RealtimeGameProvider>(context).game;
    var players = game['players'];

    if (players != null) {
      for (var player in players!.entries) {
        gameServices.playerLeaderboard
            .updatePlayer(player.key, player.value['score']);
      }
    }

    gameServices.playerLeaderboard.computeRank();

    players = gameServices.playerLeaderboard.players;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < players!.length && i < 3; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LeaderboardRow(
                    rank: i + 1,
                    score: players![i].score,
                    name: players![i].name,
                    color: colors[i]),
              ),
          ]),
    );
  }
}
