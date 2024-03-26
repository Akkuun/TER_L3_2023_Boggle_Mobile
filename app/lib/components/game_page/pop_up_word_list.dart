import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/game_page/dices.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:bouggr/components/popup.dart';
import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpWordList extends StatelessWidget {
  const PopUpWordList({super.key});

  @override
  Widget build(BuildContext context) {
    var gameServices = Provider.of<GameServices>(context, listen: true);
    var endGameServices = Provider.of<EndGameService>(context, listen: true);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return PopUp<EndGameService>(
      child: Positioned(
        top: h * 0.05,
        left: w * 0.01,
        child: Container(
            decoration: ShapeDecoration(
              color: const Color.fromARGB(255, 171, 128, 241),
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
            height: h * 0.7,
            width: w * 0.98,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color.fromRGBO(216, 191, 255, 1),
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
                    height: w * 0.96,
                    width: w * 0.96,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        key: key,
                        itemCount: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemBuilder: (context, index) {
                          return BoggleDice(
                            index: index,
                            letter: gameServices.letters[index],
                            color: endGameServices.selectedWord != null
                                ? endGameServices.selectedWord!.isAtCoord(index)
                                    ? endGameServices.selectedWord!
                                            .isFirstChild(index)
                                        ? Colors.green
                                        : Theme.of(context).primaryColor
                                    : Colors.white
                                : Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: ShapeDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                      child: const AllWordsFound()),
                ),
                BtnBoggle(
                    onPressed: () {
                      Provider.of<EndGameService>(context, listen: false)
                          .toggle(false);
                    },
                    text: 'Fermer')
              ],
            )),
      ),
    );
  }
}
