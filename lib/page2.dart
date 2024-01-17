import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //écoute du listener de MyAppState
    return Column(
      children: [
        const Text('Page 2 ??????'), //affichage de la page
        ElevatedButton(
          onPressed: () {
            appState.goToPage(0);
          },
          child: const Text('Page 1'),
        ),
      ],
    );
  }
}
