import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoggleGrille extends StatefulWidget {
  final List<String> letters;
  final bool Function(String) onWordSelectionEnd;

  const BoggleGrille({
    super.key,
    required this.letters,
    required this.onWordSelectionEnd,
  });

  @override
  BoggleGrilleState createState() {
    return BoggleGrilleState();
  }
}

class BoggleGrilleState extends State<BoggleGrille> {
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  final Set<_BoggleDice> _trackTaped = <_BoggleDice>{};
  String currentWord = "";
  bool lock = false;

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
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _BoggleDice && !_trackTaped.contains(target)) {
          String newWord = currentWord + widget.letters[target.index];
          if (_trackTaped.isNotEmpty) {
            final last = _trackTaped.last;
            if ((target.index == last.index + 1 ||
                    target.index == last.index - 1 ||
                    target.index == last.index + 4 ||
                    target.index == last.index - 4 ||
                    target.index == last.index + 3 ||
                    target.index == last.index - 3 ||
                    target.index == last.index + 5 ||
                    target.index == last.index - 5) &&
                true /* TODO : valider le mot ? */) {
              _trackTaped.add(target);
              _selectIndex(target.index);
            } else {
              _trackTaped.clear();
              setState(() {
                selectedIndexes.clear();
                lock = true;
                currentWord = "";
              });
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
      }
    }
  }

  void _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  void _clearSelection(PointerUpEvent event) {
    widget.onWordSelectionEnd(currentWord);
    _trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
      lock = false;
      currentWord = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: SizedBox(
        height: 400,
        child: Listener(
          onPointerDown: _detectTapedItem,
          onPointerMove: _detectTapedItem,
          onPointerUp: _clearSelection,
          child: GridView.builder(
            key: key,
            itemCount: 16,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: BoggleDice(
                  index: index,
                  letter: widget.letters[index],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selectedIndexes.contains(index)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        widget.letters[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BoggleDice extends SingleChildRenderObjectWidget {
  final int index;
  final String letter;

  const BoggleDice(
      {required Widget child,
      required this.index,
      required this.letter,
      Key? key})
      : super(child: child, key: key);

  @override
  _BoggleDice createRenderObject(BuildContext context) {
    return _BoggleDice(index);
  }

  @override
  void updateRenderObject(BuildContext context, _BoggleDice renderObject) {
    renderObject.index = index;
  }
}

class _BoggleDice extends RenderProxyBox {
  int index;
  _BoggleDice(this.index);
}

/*
class BoggleGrille extends StatefulWidget {
  final Widget? child;
  final List<List<String>> letters;
  final Function(String, int) updateWord;
  final Function() onPanEnd;

  const BoggleGrille({
    super.key,
    required this.letters,
    required this.updateWord,
    required this.onPanEnd,
    this.child,
  });

  @override
  State<BoggleGrille> createState() => _BoggleGrilleState();
}

class _BoggleGrilleState extends State<BoggleGrille> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    if (widget.child != null) {
      children.add(widget.child!);
    }

    var dices = <BoggleDice>[];

    widget.letters.shuffle();

    for (var i = 0; i < widget.letters.length; i++) {
      dices.add(BoggleDice(
        letters: widget.letters[i],
        position: i,
        updateWord: widget.updateWord,
        onPanEnd: widget.onPanEnd,
      ));
    }

    return Container(
        // Fond de la grille
        height: 400,
        color: Theme.of(context).secondaryHeaderColor,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: dices.length,
          itemBuilder: (BuildContext context, int index) {
            return dices[index];
          },
        )
      );
  }
}
*/