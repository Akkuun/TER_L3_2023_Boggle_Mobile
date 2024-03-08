import 'package:bouggr/components/dices.dart';
import 'package:bouggr/providers/game.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BoggleGrille extends StatefulWidget {
  final List<String> letters;
  final bool Function(String, List<(int, int)>) onWordSelectionEnd;
  final bool Function(String) isWordValid;
  final GameType mode;

  const BoggleGrille({
    super.key,
    required this.letters,
    required this.onWordSelectionEnd,
    required this.isWordValid,
    this.mode = GameType.solo,
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

  get mode => null;

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
    String newWord = currentWord + widget.letters[target.index];

    if (_trackTaped.isNotEmpty) {
      final last = _trackTaped.last;
      if (isAdjacent(target, last)) {
        isCurrentWordValid = widget.isWordValid(newWord);
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

  bool isAdjacent(BoggleDiceRender target, BoggleDiceRender last) {
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

  void _sendWordToGameLogicAndClear(PointerUpEvent event) {
    if (currentWord.length >= 3) {
      List<(int, int)> indexes = [];
      for (var index in selectedIndexes) {
        indexes.add((index ~/ 4, index % 4));
      }
      widget.onWordSelectionEnd(currentWord, indexes);
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
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width - 50,
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
                    letter: widget.letters[index],
                    color: selectedIndexes.contains(index)
                        ? isCurrentWordValid
                            ? Theme.of(context).primaryColor
                            : Colors.red
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
