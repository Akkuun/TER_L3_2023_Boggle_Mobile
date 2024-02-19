import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    void requetFireBaseConnexion() async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email.text, password: mdp.text);
      } on FirebaseAuthException catch (e) {
        print(e.message);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Erreur"),
                content: const Text(
                    "Les informations d'identification fournies sont incorrectes, mal formées ou ont expiré."),
                actions: [
                  ElevatedButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme la boîte de dialogue
                    },
                  )
                ],
              );
            });
      }
      /*
          .then((result) {
        //gestion de la connexion
        isLoading = false;
        router.goToPage(PageName.home); //redirection vers la page d'accueil
      }).catchError((err) {
        //gestion des erreurs
        
        setState(() {
          isLoading = false;
        });
      });*/
    }

    return Form(
        key: _key,
        child: Column(children: [
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailCreate);
            },
            btnSize: BtnSize.large,
            text: "Créé un compte",
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), //cela cert a définir la marge
            child: TextFormField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
              //c'est pour être sur que l'entrer soit un email fonctionnel ou non
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mail';
                } else if (!validationEmail.hasMatch(value)) {
                  return 'Adress mail non valide!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              controller: mdp,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mot de passe';
                } else if (value.length < 6) {
                  return 'Le mot de passe doit contenir au moins 6 caractères!';
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
                        child: const Text('Submit'),
                      ),
          )
        ]));
  }
}
