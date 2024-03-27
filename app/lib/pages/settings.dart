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
  const SettingsPage({Key? key}) : super(key: key);

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
  Language? _selectedLanguage = const Language('fr', 'Français', LangCode.FR);

  void _handleButtonClick() {
    // Do something when the button is clicked
  }

  Future<void> _changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
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
              errorText = "Password must be at least 6 characters long";
            });
          }
        } else {
          setState(() {
            errorText = "Passwords don't match";
          });
        }
      } else {
        setState(() {
          errorText = "User is not signed in or passwords are empty";
        });
      }
    } catch (e) {
      // An error occurred
    }
  }

  @override
  Widget build(BuildContext context) {
    var router = Provider.of<NavigationServices>(context, listen: false);

    final auth = FirebaseAuth.instance;

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
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 430,
              height: 90,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Se',
                      style: textStyleJUA,
                    ),
                    TextSpan(
                      text: 'tt',
                      style: TextStyle(
                        color: Color(0xFF1F87B3),
                        fontSize: 64,
                        fontFamily: 'Jua',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'ings',
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
                      hint: const Text('Select an language'),
                      value: _selectedLanguage,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Language selected: ${_selectedLanguage?.name ?? 'None'}',
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      enabled: FirebaseAuth.instance.currentUser != null,
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
                        labelText: 'Confirm Password',
                        errorText: errorText,
                      ),
                      obscureText: true,
                      enabled: FirebaseAuth.instance.currentUser != null,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _changePassword();
                      },
                      child: const Text('Change Password'),
                    ),
                    if (changeSuccess)
                      const Text(
                        'Password changed successfully!',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    BtnBoggle(
                      onPressed: () {
                        auth.signOut();
                        Globals.gameCode = "";
                        Globals.playerName = "";
                        router.goToPage(PageName.home);
                      },
                      btnSize: BtnSize.large,
                      text: "Déconnexion",
                    ),
                    BtnBoggle(
                      onPressed: () {
                        GameDataStorage.deleteGameResults();
                      },
                      btnType: BtnType.secondary,
                      btnSize: BtnSize.small,
                      text: "Delete cache",
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
