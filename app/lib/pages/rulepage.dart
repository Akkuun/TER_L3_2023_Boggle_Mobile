import 'package:bouggr/components/btn.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/pages/page_name.dart';

import 'package:bouggr/global.dart';

import '../providers/game.dart';

/// Page des règles du jeu

class RulePage extends StatelessWidget {
  const RulePage({super.key});
  @override
  Widget build(BuildContext context) {
    var router = Provider.of<NavigationServices>(context,
        listen: false); //recuperation du services de navigation

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const _RulesTitle(),
        const _RulesInstruction(),
        BtnBoggle(
          onPressed: () {
            router.goToPage(PageName.home);
          },
          btnType: BtnType.secondary,
          btnSize: BtnSize.large,
          text: "Go back",
        ),
      ],
    );
  }
}

class _RulesInstruction extends StatelessWidget {
  const _RulesInstruction();

  static const textStyleIBM = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'IBM Plex Sans',
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final gameServices = Provider.of<GameServices>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 181, 224, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text:
                       "ff",
                        style: textStyleIBM),
                    TextSpan(
                        text:
                            'Une lettre ne peut pas être utilisée plus d\'une fois pour un même mot.\nSeuls les mots de trois lettres ou plus comptent.\nLes accents ne sont pas importants. E peut être utilisé comme E, E, E, etc.\n',
                        style: textStyleIBM),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 181, 224, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text:
                            '\nDécompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant:',
                        style: textStyleIBM),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _RulesTitle extends StatelessWidget {
  const _RulesTitle();

  static const textStyleJUA = TextStyle(
    color: Colors.black,
    fontSize: 64,
    fontFamily: 'Jua',
    fontWeight: FontWeight.w400,
    height: 0,
  );
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 430,
        height: 70,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'R',
                style: textStyleJUA,
              ),
              TextSpan(
                text: 'u',
                style: TextStyle(
                  color: Color(0xFF1F87B3),
                  fontSize: 64,
                  fontFamily: 'Jua',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              TextSpan(
                text: 'les',
                style: textStyleJUA,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
