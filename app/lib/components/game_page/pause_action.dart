//components

import 'package:bouggr/components/global/btn.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/background_music_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

BackgroundMusicPlayer backgroundMusicPlayer = BackgroundMusicPlayer.instance;

class PauseAction extends StatelessWidget {
  const PauseAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    GameServices gameServices = Provider.of<GameServices>(
        context); // is in listen: true because we need to update the score
    return IconBtnBoggle(
      onPressed: () async {
        if (gameServices.triggerPopUp) {
          timerServices.stop();
          backgroundMusicPlayer.resume();
        } else {
          backgroundMusicPlayer.pause();
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
