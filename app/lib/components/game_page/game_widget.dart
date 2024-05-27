//components

import 'package:bouggr/components/game_page/game_front.dart';
import 'package:bouggr/components/game_page/pop_up_game_menu.dart';
import 'package:bouggr/components/game_page/wave.dart';
import 'package:bouggr/providers/firebase.dart';

import 'package:flutter/material.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation.dart';

/// Contains the animation for the background and the game front  and the pop up menu
class GameWidget extends StatelessWidget {
  final List<MapEntry<String, dynamic>>? players;
  final bool isMulti;
  const GameWidget({
    super.key,
    this.players,
    required this.isMulti,
  });

  @override
  Widget build(BuildContext context) {
    if (isMulti) {
      if (Provider.of<FirebaseProvider>(context, listen: true).user == null) {
        Provider.of<NavigationServices>(context, listen: false)
            .goToPage(PageName.login);
      }

      return Container(
        color: const Color.fromRGBO(255, 237, 172, 1),
        child: const Stack(
          children: [
            Wave(),
            GameFront(isMulti: true),
            PopUpGameMenu(),
          ],
        ),
      );
    }

    return Container(
      color: const Color.fromRGBO(255, 237, 172, 1),
      child: const Stack(
        children: [
          Wave(),
          GameFront(isMulti: false),
          PopUpGameMenu(),
        ],
      ),
    );
  }
}
