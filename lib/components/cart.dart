import 'package:bouggr/components/btn.dart';
import 'package:flutter/material.dart';

class BoggleCart extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onPressed;

  final Widget? child;

  const BoggleCart({
    super.key,
    required this.title,
    required this.action,
    required this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Center(
          child: Column(
        children: [
          Text(title),
          BtnBoggle(
            onPressed: onPressed,
            text: action,
          )
        ],
      )),
    );
  }
}
