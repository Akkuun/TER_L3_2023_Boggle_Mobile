//components

//globals

//services

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';

//utils
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bouggr/components/bottom_buttons.dart';

import '../providers/navigation.dart';

class MultiplayerGamePage extends StatefulWidget {
  const MultiplayerGamePage({super.key});

  @override
  State<MultiplayerGamePage> createState() => _MultiplayerGamePageState();
}

class _MultiplayerGamePageState extends State<MultiplayerGamePage> {
  String? _gameUID = '';
  BtnType _btnType = BtnType.secondary;

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        router.goToPage(PageName.login);
      }
    } catch (e) {
      router.goToPage(PageName.login);
    }
    FirebaseDatabase database = FirebaseDatabase.instance;

    final playerUID = FirebaseAuth.instance.currentUser!.uid;

    var playerRef = database.ref('players/$playerUID');
    playerRef.set({
      'email': user!.email,
      'score': 0,
    });

    return BottomButtons(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppTitle(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Mul",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "ti",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    "player",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            BtnBoggle(
              onPressed: () {
                router.goToPage(PageName.game);
              },
              btnSize: BtnSize.large,
              text: "Create a game",
            ),
            const Text(
              "or",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Jua',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _gameUID = value;
                    _btnType = _gameUID!.isNotEmpty ? BtnType.primary : BtnType.secondary;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Game code',
                ),
              ),
            ),
            BtnBoggle(
              onPressed: () {
                router.goToPage(PageName.home);
              },
              btnSize: BtnSize.large,
              text: "Join a game",
              btnType: _btnType,
            ),
          ],
        )
    );
  }
}