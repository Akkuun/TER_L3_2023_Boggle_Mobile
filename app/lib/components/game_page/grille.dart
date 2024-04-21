import 'package:bouggr/components/game_page/dices.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:bouggr/utils/word_score.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class BoggleGrille extends StatefulWidget {
  const BoggleGrille({
    super.key,
  });

  @override
  State<BoggleGrille> createState() {
    return _BoggleGrilleState();
  }
}

class _BoggleGrilleState extends State<BoggleGrille> {
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  final Set<BoggleDiceRender> _trackTaped = <BoggleDiceRender>{};
  String currentWord = "";
  bool isCurrentWordValid = false;
  bool lock = false;
  late GameServices gameServices;
  late Dictionary _dictionary;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);

    _dictionary = Globals.selectDictionary(gameServices.language);
    _dictionary.load();
  }

  _detectTapedItem(PointerEvent event) {
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
            !_trackTaped.contains(hit.target)) {
          _handleSelectedDice(hit.target as BoggleDiceRender);
        }
      }
    }
  }

  void _handleSelectedDice(BoggleDiceRender target) {
    String newWord = currentWord + gameServices.letters[target.index];

    if (_trackTaped.isNotEmpty) {
      final last = _trackTaped.last;
      if (_isAdjacent(target, last)) {
        isCurrentWordValid = _isWordValid(newWord);
        _trackTaped.add(target);
        _selectIndex(target.index);
      } else {
        _clearSelection();
        return;
      }
    } else {
      _trackTaped.add(target);
      _selectIndex(target.index);
    }

    setState(() {
      currentWord = newWord;
    });
  }

  bool _isAdjacent(BoggleDiceRender target, BoggleDiceRender last) {
    (int, int) targetCoords = (target.index ~/ 4, target.index % 4);
    (int, int) lastCoords = (last.index ~/ 4, last.index % 4);
    return (targetCoords.$1 - lastCoords.$1).abs() <= 1 &&
        (targetCoords.$2 - lastCoords.$2).abs() <= 1;
  }

  void _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  bool _isWordValid(String word) {
    if (word.length < 3) {
      return false;
    }
    return _dictionary.contain(word);
  }

  bool _endWordSelection(String word, List<(int, int)> indexes) {
    if (gameServices.isInWordList(word) || !_isWordValid(word)) {
      gameServices.addStrike();
      return false;
    }
    if (gameServices.gameType == GameType.multi) {
      User? user =
          Provider.of<FirebaseAuth>(context, listen: false).currentUser;

      FirebaseFunctions.instance.httpsCallable('SendWord').call({
        "gameId":
            Provider.of<RealtimeGameProvider>(context, listen: false).gameCode,
        "userId": user!.uid,
        "word": indexes
            .map((e) => {"x": e.$2, "y": e.$1})
            .toList(), // Coordonnées inversées pour le serveur
      }).then((value) {
        var logger = Logger();
        logger.i(value.data);
      });
    }
    gameServices.addScore(wordScore(word));
    gameServices.addWord(word);
    return true;
  }

  void _sendWordToGameLogicAndClear(PointerUpEvent event) {
    if (currentWord.length >= 3) {
      List<(int, int)> indexes = [];
      for (var index in selectedIndexes) {
        indexes.add((index ~/ 4, index % 4));
      }
      _endWordSelection(currentWord, indexes);
    }
    _clearSelection();
  }

  void _clearSelection() {
    _trackTaped.clear();
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
      _dictionary = Globals.selectDictionary(gameServices.language);
    });
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
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
                    !gameServices.triggerPopUp ? _detectTapedItem : null,
                onPointerMove:
                    !gameServices.triggerPopUp ? _detectTapedItem : null,
                onPointerUp: _sendWordToGameLogicAndClear,
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
      ),
    );
  }
}
