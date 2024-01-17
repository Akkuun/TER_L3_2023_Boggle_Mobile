import 'package:flutter/material.dart';

enum BtnSize { small, medium, large }

enum BtnType { primary, secondary }

class BtnBoggle extends StatelessWidget {
  final BtnType btnType;
  final BtnSize btnSize;
  final String? text;
  final GestureTapCallback onPressed;
  final bool autoResize;
  final double borderLineWidth;
  final bool removePaddings;
  final MainAxisAlignment horizontalAlignment;

  const BtnBoggle(
      {super.key,
      this.text,
      required this.onPressed,
      this.btnType = BtnType.primary,
      this.btnSize = BtnSize.medium,
      this.autoResize = true,
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
      children.add(Text(
        text!,
      ));
    }

    // Return the final button
    return RawMaterialButton(
      onPressed: onPressed,

      /// The line `fillColor: ,` is incomplete and does not have a value assigned to it. It seems to be
      /// a placeholder for specifying the fill color of the button. You need to provide a valid color
      /// value to the `fillColor` property in order to set the button's background color.
      fillColor: btnType == BtnType.primary
          ? const Color.fromARGB(255, 47, 130, 255)
          : Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
          side: btnType == BtnType.primary
              ? BorderSide(
                  color: const Color.fromARGB(255, 47, 130, 255),
                  width: borderLineWidth)
              : BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: borderLineWidth),
          borderRadius: BorderRadius.all(
              Radius.circular(size == BtnSize.small ? 12 : 16))),
      child: Row(
          mainAxisSize: autoResize ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: horizontalAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children),
    );
  }
}
