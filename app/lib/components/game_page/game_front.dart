import 'package:bouggr/components/game_page/action_and_timer.dart';
import 'package:bouggr/components/game_page/grille.dart';
import 'package:bouggr/components/game_page/scoreboard.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/components/game_page/words_found.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/game_data.dart';

class GameFront extends StatefulWidget {
  const GameFront({Key? key}) : super(key: key);

  @override
  _GameFrontState createState() => _GameFrontState();
}

class _GameFrontState extends State<GameFront> {
  LangCode _selectedLanguage = LangCode.FR;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() async {
    LangCode lang = await GameDataStorage.loadLanguage();
    setState(() {
      _selectedLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              AppTitle(fontSize: 56),
              Text(
                  'Langue sélectionnée: ${getLanguageName(_selectedLanguage)}'), // Affiche la langue sélectionnée
              ScoreBoard(),
              BoggleGrille(),
              WordsFound(),
              ActionAndTimer()
            ],
          ),
        ),
      ),
    );
  }
}
