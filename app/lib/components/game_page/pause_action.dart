//components

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/utils/BackgroundMusicPlayer.dart';

class PauseAction extends StatelessWidget {
  const PauseAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: true);
    return IconBtnBoggle(
      onPressed: () async {
        if (gameServices.triggerPopUp) {
          timerServices.stop();
          BackgroundMusicPlayer().stop();
        } else {
          timerServices.start();
        }
        gameServices.toggle(!gameServices.triggerPopUp);
      },
      icon: Icon(
        gameServices.triggerPopUp ? Icons.play_arrow : Icons.pause,
        color: Colors.black,
        size: 48,
        semanticLabel: "pause",
      ),
    );
  }
}
