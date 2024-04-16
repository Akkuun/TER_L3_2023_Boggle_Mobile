import 'package:bouggr/pages/email_create.dart';
import 'package:bouggr/pages/email_login.dart';
import 'package:bouggr/pages/end_game_detail.dart';
import 'package:bouggr/pages/home.dart';
import 'package:bouggr/pages/login.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/pages/rulepage.dart';
import 'package:bouggr/pages/multiplayer_create_join.dart';
import 'package:bouggr/pages/game.dart';
import 'package:bouggr/pages/multiplayer_game_wait.dart';
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
    PageName.multiplayerGameWait: () => const GameWaitPage(),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomInset: true, // change this to true
          body: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: _pages[router.index]?.call() ??
                  HomePage(), //affichage de la page
            ),
          ),
        );
      },
    );
  }
}
