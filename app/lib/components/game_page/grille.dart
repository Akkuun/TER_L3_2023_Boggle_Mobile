import 'package:bouggr/components/game_page/dices.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/get_all_word.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  bool lock = false;
  late GameServices gameServices;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);
    gameServices.loadDictionary();
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

  void _endWordSelection(String word, List<(int, int)> indexes) {
    var coords = indexes.map((e) => Coord(e.$1, e.$2)).toList();
    gameServices.chechWord(Word(word, coords));
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
    });
  }

  static var boxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.25),
    blurRadius: 4,
    offset: const Offset(4, 4),
  );

  @override
  Widget build(BuildContext context) {
    GameServices game = context.watch<GameServices>();

    var width = MediaQuery.of(context).size.width;

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).secondaryHeaderColor,
              boxShadow: [
                boxShadow,
              ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              height: width,
              width: width - 50,
              child: Listener(
                onPointerDown: !game.triggerPopUp ? _detectTapedItem : null,
                onPointerMove: !game.triggerPopUp ? _detectTapedItem : null,
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
                      color: _colorForIndex(index, game),
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

  Color _colorForIndex(int index, GameServices gm) {
    if (selectedIndexes.contains(index)) {
      return Theme.of(context).primaryColor;
    }
    if (gm.tipsIndex != null) {
      if (gm.tipsIndex!.x * 4 + gm.tipsIndex!.y == index) {
        return const Color.fromARGB(255, 78, 76, 175);
      }
    }
    if (gm.validWords.map((e) => e.x * 4 + e.y).contains(index)) {
      return Colors.green;
    }
    return Colors.white;
  }
}
