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
    List<Widget> children = <Widget>[];
    if (child != null) {
      children.add(child!);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 260,
          width: 180,
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
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
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
