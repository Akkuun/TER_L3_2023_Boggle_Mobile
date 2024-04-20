//components

import 'package:bouggr/components/game_page/game_front.dart';
import 'package:bouggr/components/game_page/pop_up_game_menu.dart';
import 'package:bouggr/components/game_page/wave.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation.dart';

/// Contains the animation for the background and the game front  and the pop up menu
class GameWidget extends StatelessWidget {
  final GameType gameType;
  final List<MapEntry<String, dynamic>>? players;
  const GameWidget({
    super.key,
    required this.gameType,
    this.players,
  });

  @override
  Widget build(BuildContext context) {
    User? user;
    if (gameType == GameType.multi) {
      final router = Provider.of<NavigationServices>(context, listen: false);
      try {
        user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          router.goToPage(PageName.login);
        }
      } catch (e) {
        router.goToPage(PageName.login);
      }
    }

    return Container(
      color: const Color.fromRGBO(255, 237, 172, 1),
      child: Stack(
        children: [
          const Wave(),
          GameFront(gameType: gameType, players: players),
          PopUpGameMenu(gameType: gameType, uid: user?.uid ?? ''),
        ],
      ),
    );
  }
}
