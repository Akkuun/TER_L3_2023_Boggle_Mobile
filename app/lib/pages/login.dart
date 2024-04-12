import 'package:bouggr/components/btn.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/game.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameservices = Provider.of<GameServices>(context, listen: false);
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = FirebaseAuth.instance;
    // ignore: unused_local_variable
    User? user;

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // ignore: avoid_print
        print('User is currently signed out!');
      } else {
        // ignore: avoid_print
        print('User is signed in!');
      }
    });

    return Center(
      child: Column(
        children: [
          BtnBoggle(
            onPressed: () {},
            btnSize: BtnSize.large,
            text: Globals.getText(gameservices.language, 31)
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailLogin);
            },
            btnSize: BtnSize.large,
            text: Globals.getText(gameservices.language, 33),
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailCreate);
            },
            btnSize: BtnSize.large,
            text: Globals.getText(gameservices.language, 32),
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.home);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.small,
            text: Globals.getText(gameservices.language, 14),
          ),
        ],
      ),
    );
  }
}
