import 'dart:ffi';

import 'package:bouggr/components/dice.dart';
import 'package:flutter/material.dart';

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
