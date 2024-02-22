import 'package:bouggr/pages/email_create.dart';
import 'package:bouggr/pages/email_login.dart';
import 'package:bouggr/pages/home.dart';
import 'package:bouggr/pages/login.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/pages/rulepage.dart';
import 'package:bouggr/pages/game.dart';
import 'package:bouggr/pages/stats.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/settings.dart';

class BouggrRouter extends StatefulWidget {
  const BouggrRouter({super.key});

  @override
  State<BouggrRouter> createState() => _BouggrRouter();
}

class _BouggrRouter extends State<BouggrRouter> {
  @override
  Widget build(BuildContext context) {
    var router = context
        .watch<NavigationServices>(); //écoute du listener de NavigationServices
    var selectedIndex = router.index; //récupération de l'index de la page
    Widget page;
    switch (selectedIndex) {
      //switch pour afficher la page correspondante
      case PageName.home:
        page = const HomePage();
        break;
      case PageName.game:
        page = const GamePage();

        break;
      case PageName.rules:
        page = const RulePage();
        break;
      case PageName.login:
        page = const LoginPage();
        break;
      case PageName.stats:
        page = const StatsPage();
        break;
      case PageName.emailLogin:
        page = const EmailLogIn();
      case PageName.googleLogin:
        page = const LoginPage();
      case PageName.emailCreate:
        page = const EmailCreate();
      case PageName.settings:
        page = const SettingsPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                page, //affichage de la page
              ],
            ),
          ),
        );
      },
    );
  }
}