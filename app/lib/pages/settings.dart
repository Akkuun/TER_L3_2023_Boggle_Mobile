import 'package:bouggr/providers/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';

/// Page des règles du jeu

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedLanguage;

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
          height: MediaQuery.of(context).size.height - 200,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column( //enfants
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
                    hint: Text('Select an langage'),
                    value: _selectedLanguage,
                  ),

                  Text(_selectedLanguage ?? 'No language selected'), //DropDownButtonValue
                ],
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
