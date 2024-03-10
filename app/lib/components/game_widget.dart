//components

import 'package:bouggr/components/game_front.dart';
import 'package:bouggr/components/pop_up_game_menu.dart';
import 'package:bouggr/components/wave.dart';

import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
