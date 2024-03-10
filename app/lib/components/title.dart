import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final double fontSize;
  const AppTitle({
    super.key,
    this.fontSize = 96,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
      height: 0,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'B',
            style: textStyle,
          ),
          TextSpan(
            text: 'OU',
            style: TextStyle(
              color: const Color(0xFF1E86B3),
              fontSize: fontSize,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          TextSpan(
            text: 'GGR',
            style: textStyle,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
