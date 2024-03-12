import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/game_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndGameDetail extends StatelessWidget {
  const EndGameDetail({super.key});

  @override
  Widget build(BuildContext context) {
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: true);
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    NavigationServices navigationServices =
        Provider.of<NavigationServices>(context, listen: false);

    GameResult gameResult = GameResult(
        score: gameServices.score,
        grid: gameServices.letters.join(),
        words: []);

    return Column(
      children: [
        BtnBoggle(
          onPressed: () {
            gameServices.stop();

            GameDataStorage.saveGameResult(gameResult);

            timerServices.resetProgress();
            gameServices.reset();
            navigationServices.goToPage(PageName.home);
          },
          text: "new game",
        ),
        BtnBoggle(
            onPressed: () {
              gameServices.stop();

              GameDataStorage.saveGameResult(gameResult);
              gameServices.reset();
              timerServices.resetProgress();
              navigationServices.goToPage(PageName.home);
            },
            text: "Home",
            btnType: BtnType.secondary),
      ],
    );
  }
}
