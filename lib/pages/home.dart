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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoggleCard(
                onPressed: () {
                  appState.goToPage(PageName.rules.id());
                },
                title: "Rules",
                action: 'read',
                child: const Text(
                  'Found words\n&\nearn points',
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
                  appState.goToPage(PageName.rules.id());
                },
              )
            ],
          ),
          const SizedBox(
            width: 430,
            height: 113,
            child: Text.rich(
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
