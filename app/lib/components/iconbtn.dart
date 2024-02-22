import 'package:flutter/material.dart';
import 'package:bouggr/components/btn.dart';

class IconBtnBoggle extends StatelessWidget {
  final dynamic icon;
  final BtnType btnType;
  final GestureTapCallback onPressed;
  final int width;


  const IconBtnBoggle(
      {super.key,
      required this.icon,
      required this.btnType,
      required this.onPressed,
      this.width = 50});

  @override
  Widget build(BuildContext context) {
    // Return the final button
    return  Material(
      color: Colors.transparent,
      child: Center(
        child: Ink(
          decoration: ShapeDecoration(
            color: btnType == BtnType.primary
                ? const Color.fromARGB(255, 91, 157, 255)
                : Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          child: Padding(
            // padding of 20 left right and 10 top bottom
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: IconButton(
              icon: icon,
              color: btnType == BtnType.primary
                  ? Colors.white
                  : const Color.fromARGB(255, 91, 157, 255),
              iconSize: width.toDouble(),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
