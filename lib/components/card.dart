import 'package:bouggr/components/btn.dart';
import 'package:flutter/material.dart';

class BoggleCard extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onPressed;

  final Widget? child;

  const BoggleCard({
    super.key,
    required this.title,
    required this.action,
    required this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 260,
          width: 160,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                BtnBoggle(
                  onPressed: onPressed,
                  text: action,
                )
              ],
            ),
          )),
    );
  }
}
