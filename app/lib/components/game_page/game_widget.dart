//components

import 'package:bouggr/components/game_page/game_front.dart';
import 'package:bouggr/components/game_page/pop_up_game_menu.dart';
import 'package:bouggr/components/game_page/wave.dart';

import 'package:flutter/material.dart';

/// Contains the animation for the background and the game front  and the pop up menu
class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              color: const Color.fromRGBO(255, 237, 172, 1),
            ),
            const Wave(),
            const GameFront(),
          ],
        ),
        const PopUpGameMenu(),
      ],
    );
  }
}
