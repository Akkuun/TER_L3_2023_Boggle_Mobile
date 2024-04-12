// ignore_for_file: prefer_const_constructors

import 'package:bouggr/global.dart';
import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WordsFound extends StatelessWidget {
  const WordsFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gameServices = Provider.of<GameServices>(context);

    return SizedBox(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  var words = snapshot.data;
                  if (words == null) {
                    return Text( Globals.getText(gameServices.language, 55));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(

                              "${ Globals.getText(gameServices.language, 21)} ${words.length - gameServices.words.length}"),
                          words.firstWhere(
                                      (element) => !gameServices.words
                                          .contains(element.txt),
                                      orElse: () => Word("", [])) !=
                                  null
                              ? Text(
                              "${Globals.getText(gameServices.language, 22)}  ${words.reduce((Word value, Word element) => value.txt.length > element.txt.length ? !gameServices.words.contains(value.txt) ? value : Word("", []) : !gameServices.words.contains(element.txt) ? element : Word("", [])).txt.length}")
                              : Text(Globals.getText(gameServices.language, 23)),
                        ]),
                  );
                }
                return Text( Globals.getText(gameServices.language, 54));
              },
              future: getAllWords2(gameServices.letters,
                  Globals.selectDictionary(gameServices.language)),
            ),
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
    var gameServices = Provider.of<GameServices>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SingleChildScrollView(
          child: Builder(builder: (BuildContext innerContext) {
        return FutureBuilder(
          future: getAllWords2(gameServices.letters,
              Globals.selectDictionary(gameServices.language)),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              var words = snapshot.data;
              if (words == null) {
                return Text( Globals.getText(gameServices.language, 55));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${words.length}"),
                    for (var word in words) ClickableWord(word: word)
                  ],
                ),
              );
            }
            return Text( Globals.getText(gameServices.language, 54));
          },
        );
      })),
    );
  }
}

class ClickableWord extends StatelessWidget {
  const ClickableWord({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Provider.of<EndGameService>(context, listen: false)
            .setSelectedWord(word);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(word.txt),
          IconButton(
              onPressed: () {
                String mot = word.txt;
                recupererDefinition(mot);
              },
              icon: Icon(Icons.chrome_reader_mode_rounded))
        ],
      ),
    );
  }
}

Future<void> recupererDefinition(String mot) async {
  // Mettre le mot en minuscule
  Uri url = Uri.parse(
      'https://fr.wiktionary.org/wiki/${mot.toLowerCase()}'); // String to Uri (format adresse Web)
  if (!await launchUrl(url)) {
    // Si l'ouverture de l'URL échoue
    throw Exception('Could not launch $url');
  }
}
