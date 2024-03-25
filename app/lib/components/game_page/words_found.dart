// ignore_for_file: prefer_const_constructors

import 'package:bouggr/global.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/get_all_word.dart';
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
  @override
  void initState() {
    super.initState();
    //dico = loadDictionary("fr_dico.json");

    /*_words = getAllWords(
      letters.join(),
      dico!,
    );*/
  }

  @override
  _AllWordsFoundState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: SingleChildScrollView(
          child: Builder(builder: (BuildContext innerContext) {
        return FutureBuilder(
          future: getAllWords(
              Provider.of<GameServices>(context, listen: false).letters.join(),
              Globals.selectDictionary(LangCode.FR).dictionary),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              var words = snapshot.data;

              return Column(
                children: [for (var word in words) Text(word)],
              );
            }
            return const Text('No data');
          },
        );
      })),
    );
  }
}
