//components

import 'package:bouggr/components/game_page/action_and_timer.dart';
import 'package:bouggr/components/game_page/grille.dart';
import 'package:bouggr/components/game_page/scoreboard.dart';
import 'package:bouggr/components/title.dart';

import 'package:bouggr/components/game_page/words_found.dart';
import 'package:flutter/material.dart';

class GameFront extends StatelessWidget {
  const GameFront({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              AppTitle(fontSize: 56),
              ScoreBoard(),
              BoggleGrille(),
              WordsFound(),
              ActionAndTimer()
            ],
          ),
        ),
      ),
    );
  }
}
