import 'package:bouggr/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //écoute du listener de MyAppState
    return Column(
      children: [
        const Text('Page 1 !!!!!!!!!!!!!!!!!!!!'),
        ElevatedButton(
          onPressed: () {
            appState.goToPage(1); //changement de page
          },
          child: const Text('Page 2'),
        ),
      ],
    );
  }
}
