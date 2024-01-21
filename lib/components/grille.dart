import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoggleGrille extends StatefulWidget {
  const BoggleGrille({super.key});

  @override
  BoggleGrilleState createState() {
    return BoggleGrilleState();
  }
}

class BoggleGrilleState extends State<BoggleGrille> {
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  final Set<_BoggleDice> _trackTaped = <_BoggleDice>{};

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _BoggleDice && !_trackTaped.contains(target)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
        }
      }
    }
  }

  _selectIndex(int index) {
    setState(() {
      selectedIndexes.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            return BoggleDice(
              index: index,
              child: Container(
                color: selectedIndexes.contains(index) ? Colors.red : Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }

  void _clearSelection(PointerUpEvent event) {
    _trackTaped.clear();
    setState(() {
      selectedIndexes.clear();
    });
  }
}


class BoggleDice extends SingleChildRenderObjectWidget {
  final int index;

  const BoggleDice({required Widget child, required this.index, Key? key}) : super(child: child, key: key);

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