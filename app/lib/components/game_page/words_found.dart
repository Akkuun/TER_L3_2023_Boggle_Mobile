// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:bouggr/global.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:flutter/material.dart';
import 'package:native_ffi/generated_bindings.dart';
import 'package:native_ffi/native_ffi.dart';
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

class AllWordsFound extends StatefulWidget {
  const AllWordsFound({
    super.key,
  });

  @override
  State<AllWordsFound> createState() {
    return _AllWordsFoundState();
  }
}

class _AllWordsFoundState extends State<AllWordsFound> {
  NativeStringArray? _words;
  Pointer<Void>? dico;

  @override
  void initState() {
    super.initState();
    dico = loadDictionary("assets/dictionary/fr_dico.json");

    final letters = Provider.of<GameServices>(context, listen: false).letters;
    _words = getAllWords(
      letters.join(),
      dico!,
    );
  }

  @override
  _AllWordsFoundState();

  @override
  void dispose() {
    dico ?? freeDictionary(dico!);
    _words?.free();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        children: [
          const Text('Mots trouvés :'),
          for (var i = 0; i < _words!.length; i++) Text(_words!.get(i)),
        ],
      ),
    );
  }
}
