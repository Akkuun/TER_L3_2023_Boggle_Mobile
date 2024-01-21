import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'B',
            style: TextStyle(
              color: Colors.black,
              fontSize: 96,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          TextSpan(
            text: 'OU',
            style: TextStyle(
              color: Color(0xFF1E86B3),
              fontSize: 96,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          TextSpan(
            text: 'GGR',
            style: TextStyle(
              color: Colors.black,
              fontSize: 96,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
