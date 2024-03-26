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
import 'package:native_ffi/native_ffi.dart';
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
                  width: size.width * 0.9,
                  height: size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Grid :  OVERFCEANAEBRUAS"),
                          Text("Score : ${gameServices.score}"),
                          const Text("Score Max : NaN"),
                        ],
                      ),
                      Text(
                          "Plus long mot trouvé : ${gameServices.longestWord}"),
                      const Text("Plus long mot trouvable : pas dispo"),
                      BtnBoggle(
                        onPressed: () {
                          Provider.of<EndGameService>(context, listen: false)
                              .toggle(true);
                        },
                        text: "Liste des plus long mots",
                        btnType: BtnType.third,
                      ),
                    ],
                  ),
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
                  width: size.width * 0.9,
                  height: size.height * 0.45,
                  child: const WordsFound(),
                ),
              ),
              BtnBoggle(
                onPressed: () {
                  gameServices.stop();
                  Provider.of<EndGameService>(context, listen: false)
                      .toggle(false);
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
                    Provider.of<EndGameService>(context, listen: false)
                        .toggle(true);
                    GameDataStorage.saveGameResult(gameResult);
                    gameServices.reset();
                    timerServices.resetProgress();
                    navigationServices.goToPage(PageName.home);
                  },
                  text: "Home",
                  btnType: BtnType.secondary),
            ],
          ),
        ),
        const PopUpWordList(),
      ],
    );
  }
}
