import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);

    final _auth = FirebaseAuth.instance;
    User? user;

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    return Center(
      child: Column(
        children: [
          BtnBoggle(
            onPressed: () {},
            btnSize: BtnSize.large,
            text: "connexion",
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailLogin);
            },
            btnSize: BtnSize.large,
            text: "Connexion par email",
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailCreate);
            },
            btnSize: BtnSize.large,
            text: "Créé un compte",
          ),
          BtnBoggle(
            onPressed: () {
              //deconnexion
              _auth.signOut();
              router.goToPage(PageName.home);
            },
            btnSize: BtnSize.large,
            text: "Déconnexion",
          ),
        ],
      ),
    );
  }
}
