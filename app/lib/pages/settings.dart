import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/pages/page_name.dart';

/// Page des règles du jeu

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedLanguage;
  String? _password;
  String? _confirmPassword;
  String? errorText;
  bool changeSuccess = false;

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
    var router = Provider.of<NavigationServices>(context,
        listen: false); //recuperation du services de navigation

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
                  //enfants
                  children: [
                    DropdownButton<String>(
                      items: <String>['French', 'Global']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                      },
                      hint: const Text('Select an langage'),
                      value: _selectedLanguage,
                    ),

                    Text('Langage selected : ${_selectedLanguage ?? 'None'}'),
                    //DropDownButtonValue
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
