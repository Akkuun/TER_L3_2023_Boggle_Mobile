import 'package:bouggr/components/dices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoggleGrille extends StatefulWidget {
  final List<String> letters;
  final bool Function(String) onWordSelectionEnd;
  final bool Function(String) isWordValid;

  const BoggleGrille({
    super.key,
    required this.letters,
    required this.onWordSelectionEnd,
    required this.isWordValid,
  });

  @override
  _BoggleGrilleState createState() {
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
        if (target is BoggleDiceRender && !_trackTaped.contains(target)) {
          String newWord = currentWord + widget.letters[target.index];
          if (_trackTaped.isNotEmpty) {
            final last = _trackTaped.last;
            if (target.index == last.index + 1 ||
                    target.index == last.index - 1 ||
                    target.index == last.index + 4 ||
                    target.index == last.index - 4 ||
                    target.index == last.index + 3 ||
                    target.index == last.index - 3 ||
                    target.index == last.index + 5 ||
                    target.index == last.index - 5) {
              isCurrentWordValid = widget.isWordValid(newWord);
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
    if (currentWord.length >= 3) {
      widget.onWordSelectionEnd(currentWord);
    }
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
    );
  }
}
