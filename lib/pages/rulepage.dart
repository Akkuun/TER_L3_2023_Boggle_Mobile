import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';

/// Page des règles du jeu

class RulePage extends StatelessWidget {
  const RulePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var router = Provider.of<NavigationServices>(context,
        listen: false); //recuperation du services de navigation
    const textStyleIBM = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'IBM Plex Sans',
      fontWeight: FontWeight.w600,
    );
    const textStyleJUA = TextStyle(
      color: Colors.black,
      fontSize: 64,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
      height: 0,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Padding(
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
        ),
        Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height - 200,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              'Règles de base\n\nDans une limite de temps de 3 minutes, vous devez trouver un maximum de mots en formant des chaînes de lettres contiguës. Plus le mot est long, plus les points qu\'il vous rapporte sont importants.\nVous pouvez passer d\'une lettre à la suivante située directement à gauche, à droite, en haut, en bas, ou sur l\'une des quatre cases diagonales.\n',
                          style: textStyleIBM),
                      TextSpan(
                          text:
                              'Une lettre ne peut pas être utilisée plus d\'une fois pour un même mot.\nSeuls les mots de trois lettres ou plus comptent.\nLes accents ne sont pas importants. E peut être utilisé comme E, E, E, etc.\n',
                          style: textStyleIBM),
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
        ),
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
