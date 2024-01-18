import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
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
          BtnBoggle(
            onPressed: () {},
            btnType: BtnType.secondary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoggleCard(
                onPressed: () {
                  appState.goToPage(PageName.rules.id());
                },
                title: "Rules",
                action: 'read',
              ),
              BoggleCard(
                title: "SoonTm",
                action: 'play',
                onPressed: () {
                  appState.goToPage(PageName.rules.id());
                },
              )
            ],
          ),
          const Text(
            "BOUGGR",
            style: TextStyle(
              fontSize: 48,
            ),
          ),
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
