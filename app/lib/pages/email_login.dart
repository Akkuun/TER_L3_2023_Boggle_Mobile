import 'package:bouggr/components/btn.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.dart';

class EmailLogIn extends StatefulWidget {
  const EmailLogIn({super.key});
  @override
  State<EmailLogIn> createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _key =
      GlobalKey<FormState>(); //permet de savoir si le formulaire est valide
  TextEditingController email =
      TextEditingController(); //permet de récupérer les données du formulaire
  TextEditingController mdp = TextEditingController();

  bool isLoading = false;

  final RegExp validationEmail =
      RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameservices = Provider.of<GameServices>(context, listen: false);
    final auth = Provider.of<FirebaseAuth>(context, listen: false);

    void requetFireBaseConnexion() async {
      try {
        // ignore: unused_local_variable
        final credential = await auth.signInWithEmailAndPassword(
            email: email.text, password: mdp.text);
        router.goToPage(PageName.home);
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print(e.message);
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                //pop up
                title: Text(Globals.getText(gameservices.language, 28)),
                content: Text(Globals.getText(gameservices.language, 29)),
                actions: [
                  ElevatedButton(
                    child: Text(Globals.getText(gameservices.language, 30)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme la a pop up
                    },
                  )
                ],
              );
            });
        setState(() {
          //on utilise le setState pour changer l'état de la variable isLoading sinon elle ne changera pas
          isLoading = false;
          FocusScope.of(context).unfocus(); // force le clavier à se fermer
        });
      }
    }

    return Form(
        key: _key,
        child: Column(children: [
          BtnBoggle(
              onPressed: () {
                router.goToPage(PageName.emailCreate);
              },
              btnSize: BtnSize.large,
              text: Globals.getText(gameservices.language, 32)),
          Padding(
            padding: const EdgeInsets.all(8.0), //cela cert a définir la marge
            child: TextFormField(
              key: const Key('emailField'),
              controller: email,
              decoration: InputDecoration(
                  labelText: Globals.getText(gameservices.language, 34)),
              keyboardType: TextInputType.emailAddress,
              //c'est pour être sur que l'entrer soit un email fonctionnel ou non
              validator: (value) {
                if (value!.isEmpty) {
                  return Globals.getText(gameservices.language, 34);
                } else if (!validationEmail.hasMatch(value)) {
                  return Globals.getText(gameservices.language, 38);
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: const Key('passwordField'),
              obscureText: true,
              controller: mdp,
              decoration: InputDecoration(
                labelText: Globals.getText(gameservices.language, 35),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Globals.getText(gameservices.language, 35);
                } else if (value.length < 6) {
                  return Globals.getText(gameservices.language, 36);
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                isLoading //operateur ternaire pour afficher le bouton ou le cercle de chargement
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue)),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            requetFireBaseConnexion();
                          }
                        },
                        child: Text(Globals.getText(gameservices.language, 39)),
                      ),
          ),
          BtnBoggle(
              onPressed: () {
                router.goToPage(PageName.login);
              },
              btnType: BtnType.secondary,
              btnSize: BtnSize.small,
              text: Globals.getText(gameservices.language, 14)),
        ]));
  }
}
