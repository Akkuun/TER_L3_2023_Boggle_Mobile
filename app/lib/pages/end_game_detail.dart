import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/game_page/pop_up_word_list.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/game_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global.dart';

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

    EndGameService endGameService =
        Provider.of<EndGameService>(context, listen: true);

    GameResult gameResult = GameResult(
        score: gameServices.score,
        grid: gameServices.letters.join(),
        words: []);

    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          color: const Color.fromARGB(255, 169, 224, 255),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const HeaderEndGameDetail(),
              WordsFoundIngame(size: size),
              if (!endGameService.triggerPopUp)
                BtnBoggle(
                  onPressed: () {
                    endGameService.hidePopUp();

                    timerServices.resetProgress();
                    gameServices.reset();
                    navigationServices.goToPage(PageName.home);
                  },
                  text: Globals.getText(gameServices.language, 25),
                ),
              if (!endGameService.triggerPopUp)
                BtnBoggle(
                    onPressed: () {
                      endGameService.hidePopUp();
                      gameServices.reset();
                      timerServices.resetProgress();
                      navigationServices.goToPage(PageName.home);
                    },
                    text: Globals.getText(gameServices.language, 56),
                    btnType: BtnType.secondary),
            ],
          ),
        ),
        const PopUpWordList(),
      ],
    );
  }
}

class WordsFoundIngame extends StatelessWidget {
  const WordsFoundIngame({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
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
            width: size.width * 0.9,
            child: const Padding(
                padding: EdgeInsets.all(8.0), child: WordsFound())),
      ),
    );
  }
}

class HeaderEndGameDetail extends StatelessWidget {
  const HeaderEndGameDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    EndGameService endGameService =
        Provider.of<EndGameService>(context, listen: true);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: true);
    return Padding(
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
        width: size.width * 0.9,
        height: size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    "${Globals.getText(gameServices.language, 61)} ${gameServices.score}"),
                Text(Globals.getText(gameServices.language, 62)),
              ],
            ),
            Text(
                "${Globals.getText(gameServices.language, 60)} ${gameServices.longestWord}"),
            Text(Globals.getText(gameServices.language, 59)),
            BtnBoggle(
              onPressed: () {
                endGameService.showPopUp();
              },
              text: Globals.getText(gameServices.language, 58),
              btnType: BtnType.third,
            ),
          ],
        ),
      ),
    );
  }
}
