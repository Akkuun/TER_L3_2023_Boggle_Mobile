import 'package:bouggr/providers/firebase.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/stats_page/game_stat.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/global.dart';

class ScoreBoard extends StatelessWidget {
  final GameType gameType = GameType.multi;
  const ScoreBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GameServices gameServices = Provider.of<GameServices>(context);
    PlayerLeaderboard playerLeaderboard = PlayerLeaderboard();

    int rank = 1;

    var players = Provider.of<RealtimeGameProvider>(context).game['players'];
    if (gameType == GameType.multi) {
      if (players != null) {
        for (var player in players!.entries) {
          playerLeaderboard.addPlayer(
            PlayerStats(
                name: player.value['email'],
                score: player.value['score'],
                uid: player.key),
          );
        }
      }
      playerLeaderboard.computeRank();
      rank = playerLeaderboard.getRank(
          Provider.of<FirebaseProvider>(context, listen: false).user?.uid ??
              '');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (gameType == GameType.multi)
          GameStat(
            orientation:
                (gameType == GameType.multi) ? Axis.horizontal : Axis.vertical,
            statName: Globals.getText(gameServices.language, 18),
            statValue: rank.toString(),
          ),
        GameStat(
          orientation:
              (gameType == GameType.multi) ? Axis.horizontal : Axis.vertical,
          statName: Globals.getText(gameServices.language, 20),
          statValue: gameServices.score.toString(),
        ),
        GameStat(
          orientation:
              (gameType == GameType.multi) ? Axis.horizontal : Axis.vertical,
          statName: Globals.getText(gameServices.language, 19),
          statValue: 'x${gameServices.strikes}',
        ),
      ],
    );
  }
}
