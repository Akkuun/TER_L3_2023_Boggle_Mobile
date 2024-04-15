import 'package:bouggr/components/game_page/dices.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:bouggr/utils/word_score.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BoggleGrille extends StatefulWidget {
  const BoggleGrille({
    super.key,
  });

  @override
  State<BoggleGrille> createState() {
    return BoggleGrilleState();
  }
}

class BoggleGrilleState extends State<BoggleGrille> {
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  final Set<BoggleDiceRender> trackTaped = <BoggleDiceRender>{};
  String currentWord = "";
  bool isCurrentWordValid = false;
  bool lock = false;
  late GameServices gameServices;
  late Dictionary dictionary;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);

    dictionary = Globals.selectDictionary(gameServices.language);
    dictionary.load();
  }

  detectTapedItem(PointerEvent event) {
    if (lock) {
      return;
    }
    final RenderBox box =
        key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;

    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);

    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        if (hit.target is BoggleDiceRender &&
            !trackTaped.contains(hit.target)) {
          handleSelectedDice(hit.target as BoggleDiceRender);
        }
      }
    }
  }

  void handleSelectedDice(BoggleDiceRender target) {
    String newWord = currentWord + gameServices.letters[target.index];

    if (trackTaped.isNotEmpty) {
      final last = trackTaped.last;
      if (isAdjacent(target, last)) {
        isCurrentWordValid = isWordValid(newWord);
        trackTaped.add(target);
        selectIndex(target.index);
      } else {
        clearSelection();
        return;
      }
    } else {
      trackTaped.add(target);
      selectIndex(target.index);
    }

    setState(() {
      currentWord = newWord;
    });
  }

  bool isAdjacent(BoggleDiceRender target, BoggleDiceRender last) {
    (int, int) targetCoords = (target.index ~/ 4, target.index % 4);
    (int, int) lastCoords = (last.index ~/ 4, last.index % 4);
    return (targetCoords.$1 - lastCoords.$1).abs() <= 1 &&
        (targetCoords.$2 - lastCoords.$2).abs() <= 1;
  }

  void selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  bool isWordValid(String word) {
    if (word.length < 3) {
      return false;
    }
    return dictionary.contain(word);
  }

  bool endWordSelection(String word, List<(int, int)> indexes) {
    if (gameServices.isInWordList(word) || !isWordValid(word)) {
      gameServices.addStrike();
      return false;
    }
    gameServices.addScore(wordScore(word));
    gameServices.addWord(word);
    return true;
  }

  void sendWordToGameLogicAndClear(PointerUpEvent event) {
    if (currentWord.length >= 3) {
      List<(int, int)> indexes = [];
      for (var index in selectedIndexes) {
        indexes.add((index ~/ 4, index % 4));
      }
      endWordSelection(currentWord, indexes);
    }
    clearSelection();
  }

  void clearSelection() {
    trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
      lock = false;
      currentWord = "";
      isCurrentWordValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    GameServices gameServices = context.watch<GameServices>();

    setState(() {
      dictionary = Globals.selectDictionary(gameServices.language);
    });
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).secondaryHeaderColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(4, 4),
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SizedBox(
            height: width,
            width: width - 50,
            child: Listener(
              onPointerDown:
                  !gameServices.triggerPopUp ? detectTapedItem : null,
              onPointerMove:
                  !gameServices.triggerPopUp ? detectTapedItem : null,
              onPointerUp: sendWordToGameLogicAndClear,
              child: GridView.builder(
                key: key,
                itemCount: 16,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  return BoggleDice(
                    index: index,
                    letter: gameServices.letters[index],
                    color: selectedIndexes.contains(index)
                        ? isCurrentWordValid
                            ? Theme.of(context).primaryColor
                            : Colors.red
                        : gameServices.tipsIndex != null
                            ? gameServices.tipsIndex!.x * 4 +
                                        gameServices.tipsIndex!.y ==
                                    index
                                ? Colors.green
                                : Colors.white
                            : Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}