import 'package:flutter/material.dart';

enum BtnSize { small, medium, large }

enum BtnType { primary, secondary, square, third }

class BtnBoggle extends StatelessWidget {
  final BtnType btnType;
  final BtnSize btnSize;
  final String? text;
  final GestureTapCallback onPressed;
  final double borderLineWidth;
  final bool removePaddings;
  final MainAxisAlignment horizontalAlignment;

  Color switchColor(BtnType btnType) {
    switch (btnType) {
      case BtnType.primary:
        return const Color.fromARGB(255, 89, 150, 194);
      case BtnType.secondary:
        return Colors.white;
      case BtnType.third:
        return const Color(0xFFAB80F1);
      default:
        return Colors.white;
    }
  }

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: BtnType.square == btnType ? 64 : 330,
        height: BtnType.square == btnType ? 64 : 45,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => switchColor(btnType))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            )),
      ),
    );
  }
}

class IconBtnBoggle extends StatelessWidget {
  final BtnType btnType;
  final BtnSize btnSize;
  final Icon icon;
  final GestureTapCallback onPressed;
  final MainAxisAlignment horizontalAlignment;

  const IconBtnBoggle(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.btnType = BtnType.primary,
      this.btnSize = BtnSize.medium,
      this.horizontalAlignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: btnSize != BtnSize.small ? 64 : 45,
      width: btnSize != BtnSize.small ? 64 : 45,
      decoration: BoxDecoration(
          color: MaterialStateColor.resolveWith((states) =>
              BtnType.primary == btnType
                  ? const Color.fromARGB(255, 89, 150, 194)
                  : Colors.white),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ]),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
