import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/firebase.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/post_game_services.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/providers/stat_provider.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/router.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  //DynamicLibrary.open('libsum.so');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    Provider<FirebaseProvider>(
      create: (_) => FirebaseProvider(
        FirebaseAuth.instance,
        FirebaseFirestore.instance,
        FirebaseDatabase.instance,
        FirebaseFunctions.instance,
      ),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // Force portrait mode
    GameDataStorage.init(
      Provider.of<FirebaseProvider>(context, listen: false).firebaseFirestore,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationServices()),
        ChangeNotifierProvider(create: (context) => GameServices()),
        ChangeNotifierProvider(create: (context) => TimerServices()),
        ChangeNotifierProvider(create: (context) => EndGameService()),
        ChangeNotifierProvider(create: (context) => RealtimeGameProvider()),
        ChangeNotifierProvider(create: (context) => PostGameServices()),
        ChangeNotifierProvider(create: (context) => StatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bouggr',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 89, 150, 194)),
        ),
        home: const BouggrRouter(),
      ),
    );
  }
}
