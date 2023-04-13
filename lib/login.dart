import 'package:flutter/material.dart';
import 'package:my_videogames/userDao.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'createAccount.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidemdp = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? mdp;

  @override
  Widget build(BuildContext context) {
    String message = "";
    final messageError = ModalRoute.of(context)!.settings.arguments;
    if (messageError != null) {
      message = messageError.toString();
    }
    if (messageError.toString() == "Instance of 'Connexion'") {
      message = "Vous êtes déconnecté(e).";
    }

    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black54,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProgressHUD(
              child: Form(
                key: globalFormKey,
                child: _loginUI(context, message),
              ),
              inAsyncCall: isAPIcallProcess,
              opacity: 0.3,
              key: UniqueKey(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAccount())); // ce que va exécuter votre bouton
                    },
                    child: const Center(
                      child: Text('Créer un nouveau compte',  style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),),
                    ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.5, color: Colors.deepPurpleAccent),
                    minimumSize: Size(349, 55),),


    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context, String message) {
    return  SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  "Bienvenue !",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                      color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 50, right : 50, top: 10, bottom: 30),

                child: Text(
                  "Veuillez vous connecter ou créer un nouveau compte pour utiliser l'application.",
                  style: TextStyle(

                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              FormHelper.inputFieldWidget(context, "email", "                                   E-mail",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Le champ ne peut être vide";
                }
                return null;
              }, (onSaved) {
                email = onSaved;
              },

                  hintFontSize: 17,
                  backgroundColor: Colors.white10,
                  borderFocusColor: Colors.black54,
                  borderColor: Colors.black54,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.8),
                  borderRadius: 5),

              Padding(
                padding: const EdgeInsets.only(top: 15, bottom:10),
                child: FormHelper.inputFieldWidget(
                  context,

                  "Mot_de_passe",
                  "                             Mot de passe",
                  (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Le mot de passe ne peut être vide";
                    }
                    return null;
                  },
                  (onSaved) {
                    mdp = onSaved;
                  },
                  hintFontSize: 17,
                  backgroundColor: Colors.white10,
                  borderFocusColor: Colors.black54,
                  borderColor: Colors.black54,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.8),
                  borderRadius: 5,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Center(
                child: FormHelper.submitButton(" Se Connecter", () {
                  dynamic validate = globalFormKey.currentState?.validate();
                  if (validate != null && validate) {
                    globalFormKey.currentState?.save();
                    UserDAO.Login(context, email, mdp);
                  }
                },
                    fontSize: 17.0,
                    width:355.0,
                    height:55.0,
                    btnColor: Colors.deepPurpleAccent,
                    borderColor: Colors.black54,
                    txtColor: Colors.white,
                    borderRadius: 5),
              )
            ]),

    );
  }
}
