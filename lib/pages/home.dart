import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        BtnBoggle(onPressed: () {}),
        const Row(
          children: [],
        ),
        Text("BOUGGR"),
        BtnBoggle(
          onPressed: () {
            appState.goToPage(PageName.game.get());
          },
          btnSize: BtnSize.large,
          text: "SinglePlayer",
        ),
        BtnBoggle(
          onPressed: () {
            appState.goToPage(PageName.game.get());
          },
          btnType: BtnType.secondary,
          btnSize: BtnSize.large,
          text: "Multiplayer",
        )
      ],
    );
  }
}
