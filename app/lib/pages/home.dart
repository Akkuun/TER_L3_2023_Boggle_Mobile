import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);
    var welcomeWidget;
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        welcomeWidget = Text(
          "Bienvenue,\n ${user.email}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        );
      }
    } catch (e) {
      // exception
    }
    return BottomButtons(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoggleCard(
                onPressed: () {
                  router.goToPage(PageName.rules);
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
                  router.goToPage(PageName.rules);
                },
              ),
            ],
          ),
          const SizedBox(
            width: 430,
            height: 113,
            child: AppTitle(),
          ),
          BtnBoggle(
            onPressed: () {
              if (gameServices.start(LangCode.FR, GameType.solo)) {
                router.goToPage(PageName.game);
              }
            },
            btnSize: BtnSize.large,
            text: "SinglePlayer",
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.multiplayer);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.large,
            text: "Multiplayer",
          ),
          welcomeWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}
