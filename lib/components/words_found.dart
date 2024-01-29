// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WordsFound extends StatelessWidget {
  const WordsFound({
    super.key,
    required this.previousWords,
  });

  final List<String> previousWords;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        children: [
          const Text('Mots selectionnés :'),
          for (var word in previousWords) Text(word),
        ],
      ),
    );
  }
}
