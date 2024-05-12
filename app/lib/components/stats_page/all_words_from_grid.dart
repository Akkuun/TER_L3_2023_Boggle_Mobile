import 'package:bouggr/components/game_page/words_found.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/post_game_services.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllWordsFromGrid extends StatelessWidget {
  const AllWordsFromGrid({super.key});

  @override
  Widget build(BuildContext context) {
    var postGameService = Provider.of<PostGameServices>(context, listen: false);
    var gameServices = Provider.of<GameServices>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SingleChildScrollView(
          child: Builder(builder: (BuildContext innerContext) {
        return FutureBuilder(
          future: getAllWords2(postGameService.grid?.split('') ?? [],
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
                return Text(Globals.getText(gameServices.language, 55));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${words.length}"),
                    for (var word in words) ClickableWordPostGame(word: word)
                  ],
                ),
              );
            }
            return Text(Globals.getText(gameServices.language, 54));
          },
        );
      })),
    );
  }
}

class ClickableWordPostGame extends StatelessWidget {
  const ClickableWordPostGame({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Provider.of<PostGameServices>(context, listen: false)
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
              icon: const Icon(Icons.chrome_reader_mode_rounded))
        ],
      ),
    );
  }
}
