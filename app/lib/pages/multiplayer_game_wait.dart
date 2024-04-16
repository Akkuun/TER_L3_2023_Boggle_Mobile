//globals
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';

//services
import 'package:bouggr/providers/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/game_page/game_widget.dart';
import '../components/title.dart';
import '../providers/navigation.dart';

class GameWaitPage extends StatefulWidget {
  final GameType mode;

  const GameWaitPage({
    super.key,
    this.mode = GameType.solo,
  });

  @override
  State<GameWaitPage> createState() => _GameWaitPageState();
}

class _GameWaitPageState extends State<GameWaitPage> {
  late GameServices gameServices;
  final Stream<QuerySnapshot> _usersStream =
    FirebaseFirestore.instance.collection('games/${Globals.gameCode}/players').snapshots();
  late Widget playerList;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);
  }

  void updatePlayers(data) {
    playerList = ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index]['name']),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Game code : ${Globals.gameCode}");
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('games/${Globals.gameCode}/players');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      updatePlayers(data);
    });

    User? user;
    final router = Provider.of<NavigationServices>(context, listen: false);
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        router.goToPage(PageName.login);
      }
    } catch (e) {
      router.goToPage(PageName.login);
    }


    updatePlayers(
      [
        {"name": user!.uid},
      ]
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AppTitle(),
        const Text('Waiting for other players...'),
        SizedBox(
          height: 200,
            child: playerList
        ),
        BtnBoggle( // Start game
          onPressed: (){

          },
          text: Globals.getText(gameServices.language, 63),
        ),
        BtnBoggle( // Leave game
          onPressed: (){
            FirebaseFunctions.instance.httpsCallable('LeaveGame').call({"userId": user!.uid,});
            router.goToPage(PageName.home);
          }, text: Globals.getText(gameServices.language, 64),
          btnType: BtnType.secondary,
        ),
      ],
    );
  }
}
