import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BoggleDice extends SingleChildRenderObjectWidget {
  final int index;
  final String letter;
  Color color;

  BoggleDice(
      {required this.index,
      required this.letter,
      required this.color,
      Key? key})
      : super(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: color),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ),
            key: key);

  @override
  BoggleDiceRender createRenderObject(BuildContext context) {
    return BoggleDiceRender(index);
  }

  @override
  void updateRenderObject(BuildContext context, BoggleDiceRender renderObject) {
    renderObject.index = index;
  }
}

class BoggleDiceRender extends RenderProxyBox {
  int index;
  BoggleDiceRender(this.index);
}
