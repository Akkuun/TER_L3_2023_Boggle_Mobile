import 'package:bouggr/components/game_page/action_and_timer.dart';
import 'package:bouggr/components/game_page/grille.dart';
import 'package:bouggr/components/game_page/scoreboard.dart';
import 'package:bouggr/components/game_page/leaderboard.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/providers/game.dart';

import 'package:bouggr/utils/player_leaderboard.dart';

class GameFront extends StatelessWidget {
  final GameType gameType;
  final List<MapEntry<String, dynamic>>? players;
  const GameFront({
    super.key,
    required this.gameType,
    this.players,
  });



  @override
  Widget build(BuildContext context) {
    PlayerLeaderboard playerLeaderboard = PlayerLeaderboard();
    playerLeaderboard.init();
    int? rank;
    if (gameType == GameType.multi) {
      if (players != null) {
        for (int i = 0; i < players!.length; i++) {
          try {
            playerLeaderboard.addPlayer(
              PlayerStats(
                  name: players![i].value['email'],
                  score: players![i].value['score'],
                  uid: players![i].key),
            );
          } catch (e) {
            playerLeaderboard.addPlayer(
              PlayerStats(
                  name: 'Player ${i + 1}',
                  score: -1,
                  uid: players![i].key),
            );
          }
        }
      }
    }
    playerLeaderboard.computeRank();
    rank = playerLeaderboard.getPlayer(FirebaseAuth.instance.currentUser!.uid).rank;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTitle(fontSize: gameType == GameType.multi ? 46 : 56),
            if (gameType == GameType.multi) LeaderBoard(players: playerLeaderboard.firstn(3)),
            ScoreBoard(gameType: gameType, rank: rank),
            BoggleGrille(gameType: gameType),
            const WordsFound(),
            const ActionAndTimer()
          ],
        ),
      ),
    );
  }
}
