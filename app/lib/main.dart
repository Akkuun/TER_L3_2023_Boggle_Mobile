import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/router.dart';

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
    Provider<FirebaseAuth>(
      create: (_) => FirebaseAuth.instance,
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationServices()),
        ChangeNotifierProvider(create: (context) => GameServices()),
        ChangeNotifierProvider(create: (context) => TimerServices()),
        ChangeNotifierProvider(create: (context) => EndGameService()),
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
