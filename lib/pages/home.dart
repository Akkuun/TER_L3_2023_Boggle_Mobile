import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NavigationServices>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoggleCard(
                onPressed: () {
                  appState.goToPage(PageName.rules);
                },
                title: "Rules",
                action: 'read',
                child: const Text(
                  'Find words\n&\nearn points',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              BoggleCard(
                title: "SoonTm",
                action: 'play',
                onPressed: () {
                  appState.goToPage(PageName.rules);
                },
              )
            ],
          ),
          const SizedBox(
            width: 430,
            height: 113,
            child: AppTitle(),
          ),
          BtnBoggle(
            onPressed: () {
              if (Provider.of<GameServices>(context, listen: false)
                  .start(LangCode.FR, GameType.solo)) {
                appState.goToPage(PageName.game);
              }
            },
            btnSize: BtnSize.large,
            text: "SinglePlayer",
          ),
          BtnBoggle(
            onPressed: () {
              if (Provider.of<GameServices>(context, listen: false)
                  .start(LangCode.FR, GameType.multi)) {
                appState.goToPage(PageName.game);
              }
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
