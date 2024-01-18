import 'package:flutter/material.dart';

enum BtnSize { small, medium, large }

enum BtnType { primary, secondary }

class BtnBoggle extends StatelessWidget {
  final BtnType btnType;
  final BtnSize btnSize;
  final String? text;
  final GestureTapCallback onPressed;
  final double borderLineWidth;
  final bool removePaddings;
  final MainAxisAlignment horizontalAlignment;

  const BtnBoggle(
      {super.key,
      this.text,
      required this.onPressed,
      this.btnType = BtnType.primary,
      this.btnSize = BtnSize.medium,
      this.borderLineWidth = 1,
      this.removePaddings = false,
      this.horizontalAlignment = MainAxisAlignment.center});

  get size => null;

  @override
  Widget build(BuildContext context) {
    // Define a list to store our button's inner elements
    var children = <Widget>[];

    // If text is provided, add it to the button
    if (text != null) {
      children.add(Text(text!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
            height: 0,
          )));
    }

    // Return the final button
    return SizedBox(
      width: 330,
      height: 45,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) =>
                  BtnType.primary == btnType
                      ? Color.fromARGB(255, 91, 157, 255)
                      : Colors.white)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          )),
    );
  }
}
