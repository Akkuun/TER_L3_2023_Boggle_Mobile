import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoggleDice extends SingleChildRenderObjectWidget {
  final int index;
  final String letter;
  final Color color;

  BoggleDice(
      {required this.index,
      required this.letter,
      required this.color,
      super.key})
      : super(
            child: DiceFront(
          color: color,
          letter: letter,
        ));

  @override
  BoggleDiceRender createRenderObject(BuildContext context) {
    return BoggleDiceRender(index);
  }

  @override
  void updateRenderObject(BuildContext context, BoggleDiceRender renderObject) {
    renderObject.index = index;
  }
}

class DiceFront extends StatelessWidget {
  final Color color;
  static const black = Colors.black;
  final String letter;

  const DiceFront({
    super.key,
    required this.color,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.25),
              offset: const Offset(4, 4),
              blurRadius: 4,
            )
          ]),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: black,
            fontSize: 32,
            fontFamily: "Jua",
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
    );
  }
}

class BoggleDiceRender extends RenderProxyBox {
  int index;
  BoggleDiceRender(this.index);
}
