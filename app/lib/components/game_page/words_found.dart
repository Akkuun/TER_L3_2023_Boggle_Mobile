// ignore_for_file: prefer_const_constructors

import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordsFound extends StatelessWidget {
  const WordsFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final previousWords = Provider.of<GameServices>(context).words;

    return SizedBox(
      height: 150,
      child: ListView(
        children: [
          const Text('Mots trouvés :'),
          for (var word in previousWords) Text(word),
        ],
      ),
    );
  }
}
