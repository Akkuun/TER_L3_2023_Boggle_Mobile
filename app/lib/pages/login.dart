import 'package:bouggr/components/global/btn.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameservices = Provider.of<GameServices>(context, listen: false);

    return Center(
      child: Column(
        children: [
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailLogin);
            },
            btnSize: BtnSize.large,
            text: Globals.getText(gameservices.language, 33),
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailCreate);
            },
            btnSize: BtnSize.large,
            text: Globals.getText(gameservices.language, 32),
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.home);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.small,
            text: Globals.getText(gameservices.language, 14),
          ),
        ],
      ),
    );
  }
}
