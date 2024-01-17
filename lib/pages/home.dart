import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/cart.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Column(
        children: [
          BtnBoggle(onPressed: () {}),
          Row(
            children: [
              BoggleCart(
                onPressed: () {
                  appState.goToPage(PageName.rules.id());
                },
                title: "Rules",
                action: 'read',
              ),
              BoggleCart(
                title: "Rules",
                action: 'play',
                onPressed: () {
                  appState.goToPage(PageName.rules.id());
                },
              )
            ],
          ),
          const Text("BOUGGR"),
          BtnBoggle(
            onPressed: () {
              appState.goToPage(PageName.game.id());
            },
            btnSize: BtnSize.large,
            text: "SinglePlayer",
          ),
          BtnBoggle(
            onPressed: () {
              appState.goToPage(PageName.game.id());
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.large,
            text: "Multiplayer",
          )
        ],
      ),
    );
  }
}
