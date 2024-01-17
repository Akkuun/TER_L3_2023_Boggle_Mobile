import 'package:bouggr/pages/home.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/page1.dart';
import 'package:bouggr/page2.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bouggr',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 80, 190, 253)),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<MyAppState>(); //écoute du listener de MyAppState
    var selectedIndex = appState.index; //récupération de l'index de la page
    Widget page;
    switch (selectedIndex) {
      //switch pour afficher la page correspondante
      case 0:
        page = HomePage();
        break;
      case 1:
        page = const Page2();
        break;
      case 2:
        page = const Page2();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bouggr'),
          ),
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
