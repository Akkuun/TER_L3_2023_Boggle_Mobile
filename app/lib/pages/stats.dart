import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';

/// Page des règles du jeu

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);
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
                    text: 'St',
                    style: textStyleJUA,
                  ),
                  TextSpan(
                    text: 'a',
                    style: TextStyle(
                      color: Color(0xFF1F87B3),
                      fontSize: 64,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: 'ts',
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
                      TextSpan(text: 'Stats\n', style: textStyleIBM),
                      TextSpan(text: 'Soon\n', style: textStyleIBM),
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
