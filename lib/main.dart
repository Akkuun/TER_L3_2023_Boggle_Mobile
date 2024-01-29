import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationServices()),
        ChangeNotifierProvider(create: (context) => GameServices()),
        ChangeNotifierProvider(create: (context) => TimerServices())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bouggr',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 80, 190, 253)),
        ),
        home: const BouggrRouter(),
      ),
    );
  }
}
