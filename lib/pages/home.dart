import 'package:bouggr/components/btn.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BtnBoggle(onPressed: onPressed),
        const Row(
          children: [],
        ),
        Text("BOUGGR"),
        BtnBoggle(
          onPressed: onPressed,
          btnSize: BtnSize.large,
        ),
        BtnBoggle(
          onPressed: onPressed,
          btnType: BtnType.secondary,
          btnSize: BtnSize.large,
        )
      ],
    );
  }

  void onPressed() {}
}
