import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailCreate extends StatefulWidget {
  const EmailCreate({super.key});
  @override
  State<EmailCreate> createState() => _EmailCreateState();
}

class _EmailCreateState extends State<EmailCreate> {
  final _key =
      GlobalKey<FormState>(); //permet de savoir si le formulaire est valide
  TextEditingController email =
      TextEditingController(); //permet de récupérer les données du formulaire
  TextEditingController mdp = TextEditingController();
  TextEditingController mdp2 = TextEditingController();

  bool isLoading = false;

  final RegExp validationEmail =
      RegExp(r'^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);

    Future<void> requetFireBaseCreation() async {
      if (mdp.text != mdp2.text) {
        // Les mots de passe ne correspondent pas
        isLoading = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Erreur"),
                content: const Text("Les mots de passe ne correspondent pas."),
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
      } else {
        try {
          // ignore: unused_local_variable
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text, password: mdp.text);
          router.goToPage(PageName.home);
        } on FirebaseAuthException catch (e) {
          // ignore: avoid_print
          print(e.message);
          Widget text;
          if (e.code == 'email-already-in-use') {
            text = const Text('L\'email est déjà utilisé par un autre compte.');
          } else {
            text = const Text('Erreur inconnue');
          }
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  //pop up
                  title: const Text("Erreur"),
                  content: text,
                  actions: [
                    ElevatedButton(
                      child: const Text("Ok"),
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
            FocusScope.of(context).unfocus(); //force la fermeture du clavier
          });
        }
      }
    }

    return Form(
        key: _key,
        child: Column(children: [
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.emailLogin);
            },
            btnSize: BtnSize.large,
            text: "Déjà un compte?",
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), //cela cert a définir la marge
            child: TextFormField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
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
            child: TextFormField(
              obscureText: true,
              controller: mdp2,
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
                            requetFireBaseCreation();
                          }
                        },
                        child: const Text('Submit'),
                      ),
          )
        ]));
  }
}
