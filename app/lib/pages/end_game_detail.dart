import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/game_page/words_found.dart';
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

    WordsFound wordsFound = const WordsFound();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            child: wordsFound,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.45,
            child: wordsFound,
          ),
        ),
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
