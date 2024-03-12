import 'package:bouggr/pages/email_create.dart';
import 'package:bouggr/pages/email_login.dart';
import 'package:bouggr/pages/end_game_detail.dart';
import 'package:bouggr/pages/home.dart';
import 'package:bouggr/pages/login.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/pages/rulepage.dart';
import 'package:bouggr/pages/multiplayer_create_join.dart';
import 'package:bouggr/pages/game.dart';
import 'package:bouggr/pages/start_game.dart';

import 'package:bouggr/pages/stats.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/settings.dart';

class BouggrRouter extends StatefulWidget {
  const BouggrRouter({super.key});

  @override
  State<BouggrRouter> createState() => _BouggrRouter();
}

class JoinMulti extends StatelessWidget {
  const JoinMulti({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return const MultiplayerCreateJoinPage();
      } else {
        return const LoginPage();
      }
    } catch (e) {
      return const LoginPage();
    }
  }
}

class _BouggrRouter extends State<BouggrRouter> {
  final Map<PageName, Function> _pages = {
    PageName.home: () => HomePage(),
    PageName.game: () => const GamePage(),
    PageName.rules: () => const RulePage(),
    PageName.multiplayerCreateJoin: () => const JoinMulti(),
    PageName.multiplayerGame: () => const GamePage(mode: GameType.multi),
    PageName.login: () => const LoginPage(),
    PageName.stats: () => const StatsPage(),
    PageName.emailLogin: () => const EmailLogIn(),
    PageName.googleLogin: () => const LoginPage(),
    PageName.emailCreate: () => const EmailCreate(),
    PageName.settings: () => const SettingsPage(),
    PageName.startGame: () => const StartGamePage(),
    PageName.detail: () => const EndGameDetail(),
  };
  @override
  Widget build(BuildContext context) {
    var router = context
        .watch<NavigationServices>(); //écoute du listener de NavigationServices
    var selectedIndex = router.index; //récupération de l'index de la page
    Widget page;

    if (_pages.containsKey(selectedIndex)) {
      page = _pages[selectedIndex]!();
    } else {
      page = HomePage();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: constraints.maxHeight,
                    child: page), //affichage de la page
              ],
            ),
          ),
        );
      },
    );
  }
}
