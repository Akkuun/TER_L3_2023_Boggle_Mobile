import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

class BoggleDice extends StatefulWidget {
  final List<String> letters;
  final int position;
  final Function(String, int) updateWord;
  final Function() onPanEnd;

  final Widget? child;

  const BoggleDice({
    super.key,
    required this.letters,
    required this.updateWord,
    required this.onPanEnd,
    this.position = 0,
    this.child,
  });

  @override
  State<BoggleDice> createState() => _BoggleDiceState();
}

class _BoggleDiceState extends State<BoggleDice> {
  var currentLetter = 0;

  String getCurrentLetter() {
    return widget.letters[currentLetter];
  }

  String rollDice() {
    var random = Random();
    var index = random.nextInt(widget.letters.length);
    currentLetter = index;
    return getCurrentLetter();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];

    if (widget.child != null) {
      children.add(widget.child!);
    }

    rollDice();

    return GestureDetector(
      onPanStart: (details) {
        widget.updateWord(getCurrentLetter(), widget.position);
      },
      onPanUpdate: (details) {
        print("button ${widget.position} is pressed");
        widget.updateWord(getCurrentLetter(), widget.position);
      },
      onPanEnd: (details) {
        widget.onPanEnd();
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Center(
            child: Text(
              getCurrentLetter(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Jua',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
