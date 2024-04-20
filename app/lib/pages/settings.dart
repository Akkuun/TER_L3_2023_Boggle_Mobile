import 'package:flutter/material.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/lang.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/pages/page_name.dart';

import '../global.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _password;
  String? _confirmPassword;
  String? errorText;
  bool changeSuccess = false;
  final list = <Language>[
    const Language('fr', 'Français', LangCode.FR),
    const Language('en', 'English', LangCode.EN),
    const Language('es', 'Español', LangCode.SP),
    const Language('rm', 'Roumain', LangCode.RM),
    const Language('gl', 'Global', LangCode.GLOBAL),
  ];
  Language? _selectedLanguage;

  Future<void> _changePassword() async {
    final gameservices = Provider.of<GameServices>(context, listen: false);
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      User? user = auth.currentUser;
      if (user != null && _password != null && _confirmPassword != null) {
        if (_password == _confirmPassword) {
          if (_password!.length >= 6) {
            await user.updatePassword(_password!);
            setState(() {
              errorText = null;
              changeSuccess = true;
            });
          } else {
            setState(() {
              errorText = Globals.getText(gameservices.language, 36);
            });
          }
        } else {
          setState(() {
            errorText = Globals.getText(gameservices.language, 40);
          });
        }
      } else {
        setState(() {
          errorText = Globals.getText(gameservices.language, 53);
        });
      }
    } catch (e) {
      // An error occurred
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedLanguage = list.firstWhere(
      (element) =>
          element.langCode ==
          Provider.of<GameServices>(context, listen: false).language,
      orElse: () => list.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    var router = Provider.of<NavigationServices>(context, listen: false);
    final gameservices = Provider.of<GameServices>(context, listen: false);
    final auth = Provider.of<FirebaseAuth>(context, listen: false);

    const textStyleJUA = TextStyle(
      color: Colors.black,
      fontSize: 64,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
      height: 0,
    );

    return BottomButtons(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 430,
              height: 90,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Globals.getText(gameservices.language, 42),
                      style: textStyleJUA,
                    ),
                    TextSpan(
                      text: Globals.getText(gameservices.language, 43),
                      style: const TextStyle(
                        color: Color(0xFF1F87B3),
                        fontSize: 64,
                        fontFamily: 'Jua',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: Globals.getText(gameservices.language, 44),
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    DropdownButton<Language>(
                      items: list
                          .map<DropdownMenuItem<Language>>((Language value) {
                        return DropdownMenuItem<Language>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                      onChanged: (Language? newValue) async {
                        setState(() {
                          _selectedLanguage = newValue;
                        });

                        if (newValue != null) {
                          await GameDataStorage.saveLanguage(newValue.langCode);
                          // ignore: use_build_context_synchronously
                          Provider.of<GameServices>(context, listen: false)
                              .setLanguage(newValue.langCode);
                        }
                      },
                      hint: Text(Globals.getText(gameservices.language, 45)),
                      value: _selectedLanguage,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${Globals.getText(gameservices.language, 46)} ${_selectedLanguage?.name ?? Globals.getText(gameservices.language, 47)}",
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: Globals.getText(gameservices.language, 35),
                      ),
                      obscureText: true,
                      enabled: auth.currentUser != null,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _confirmPassword = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: Globals.getText(gameservices.language, 48),
                        errorText: errorText,
                      ),
                      obscureText: true,
                      enabled: auth.currentUser != null,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _changePassword();
                      },
                      child: Text(Globals.getText(gameservices.language, 39)),
                    ),
                    if (changeSuccess)
                      Text(
                        Globals.getText(gameservices.language, 50),
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    BtnBoggle(
                      onPressed: () {
                        Globals.resetMultiplayerData();
                        Globals.playerName = "";
                        auth.signOut().then((value) {
                          router.goToPage(PageName.login);
                        });
                      },
                      btnSize: BtnSize.large,
                      text: Globals.getText(gameservices.language, 51),
                    ),
                    BtnBoggle(
                      onPressed: () {
                        GameDataStorage.deleteGameResults();
                      },
                      btnType: BtnType.secondary,
                      btnSize: BtnSize.small,
                      text: Globals.getText(gameservices.language, 52),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
