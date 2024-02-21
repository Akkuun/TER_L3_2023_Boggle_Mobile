//components

import 'dart:math';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/popup.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpGameMenu extends StatelessWidget {
  final int score;
  const PopUpGameMenu({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    NavigationServices navigationServices =
        Provider.of<NavigationServices>(context, listen: false);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);

    return PopUp<GameServices>(
      child: Positioned(
        top: MediaQuery.of(context).size.height * 0.5 -
            min(MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.8),
        left: min(MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1),
        child: Center(
          child: Container(
            height: min(MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.8),
            width: min(MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 181, 224, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BtnBoggle(
                  onPressed: () {
                    gameServices.toggle(false);
                    Provider.of<TimerServices>(context, listen: false).start();
                  },
                  text: "X",
                  btnType: BtnType.square,
                ),
                const Text("Game Paused", style: TextStyle(fontSize: 30)),
                Text("$score points", style: const TextStyle(fontSize: 20)),
                BtnBoggle(
                  onPressed: () {
                    gameServices.stop();
                    navigationServices.goToPage(PageName.home);
                  },
                  text: "new game",
                ),
                BtnBoggle(
                    onPressed: () {
                      gameServices.stop();
                      navigationServices.goToPage(PageName.home);
                    },
                    text: "Home",
                    btnType: BtnType.secondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
