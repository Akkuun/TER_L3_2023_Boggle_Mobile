import 'package:bouggr/components/global/btn.dart';
import 'package:bouggr/components/game_page/dices.dart';
import 'package:bouggr/components/global/popup.dart';
import 'package:bouggr/components/stats_page/all_words_from_grid.dart';
import 'package:bouggr/providers/post_game_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostGameDetailPopUp extends StatelessWidget {
  const PostGameDetailPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var postGameServices = Provider.of<PostGameServices>(context);
    return PopUp<PostGameServices>(
      child: Positioned(
        top: h * 0.04,
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
            height: h * .92,
            width: w * 0.98,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            letter: postGameServices.grid?[index] ?? '',
                            color: postGameServices.selectedWord != null
                                ? postGameServices.selectedWord!
                                        .isAtCoord(index)
                                    ? postGameServices.selectedWord!
                                            .isFirstChild(index)
                                        ? const Color.fromARGB(
                                            255, 175, 149, 76)
                                        : Color.fromARGB(
                                            255,
                                            0,
                                            255 -
                                                ((postGameServices.selectedWord!
                                                            .indexOfCoords(
                                                                index)) *
                                                        256 ~/
                                                        postGameServices
                                                            .selectedWord!
                                                            .txt
                                                            .length +
                                                    1),
                                            200)
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
                      child: const AllWordsFromGrid()),
                ),
                BtnBoggle(
                    btnType: BtnType.secondary,
                    onPressed: () {
                      postGameServices.hidePopUp();
                      postGameServices.resetGrid();
                      postGameServices.resetSelectedWord();
                    },
                    text: 'Close'),
              ],
            )),
      ),
    );
  }
}
