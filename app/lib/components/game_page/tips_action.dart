//components

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TipsAction extends StatelessWidget {
  const TipsAction({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);
    return IconBtnBoggle(
      onPressed: () {
        getAllWords2(gameServices.letters,
                Globals.selectDictionary(gameServices.language))
            .then((value) {
          if (value.isNotEmpty) {
            gameServices.setTipsIndex(value
                .firstWhere(
                    (element) => !gameServices.words.contains(element.txt))
                .coords
                .first);
          }
        });
      },
      icon: const Icon(
        Icons.live_help_outlined,
        color: Colors.black,
        size: 48,
        semanticLabel: "pause",
      ),
    );
  }
}
