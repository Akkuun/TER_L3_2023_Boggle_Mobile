import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);
    Widget welcomeWidget;
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
      } else {
        welcomeWidget = BtnBoggle(
          onPressed: () {
            router.goToPage(PageName.login);
          },
          btnSize: BtnSize.large,
          text: "Login",
        );
      }
    } catch (e) {
      welcomeWidget = const SizedBox();
    }
    return BottomButtons(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: BoggleCard(
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
              ),
              const SizedBox(width: 16), // Ajoutez un espacement entre les cartes si nécessaire
              Expanded(
                child: BoggleCard(
                  title: "SoonTm",
                  action: 'play',
                  onPressed: () {
                    router.goToPage(PageName.rules);
                  },
                ),
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
              Globals.selectDictionary(gameServices.language).load();
              router.goToPage(PageName.startGame);
              Provider.of<EndGameService>(context, listen: false)
                  .resetSelectedWord();
            },
            btnSize: BtnSize.large,
            text: "SinglePlayer",
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.multiplayerCreateJoin);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.large,
            text: "Multiplayer",
          ),
          welcomeWidget,
        ],
      ),
    );
  }
}
