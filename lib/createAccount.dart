import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import 'userDao.dart';
import 'affichageGame.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState  extends State<CreateAccount> {bool isAPIcallProcess = false;
bool hidemdp = true;
GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
String? nom;
String? email;
String? mdp;
String? checkMdp;
    @override
    Widget build(BuildContext context) {
      String message = "";
      final messageError = ModalRoute.of(context)!.settings.arguments;
      if (messageError != null) {
        message = messageError.toString();
      }
      if (messageError.toString() == "Instance of 'Connexion'") {
        message = "Vous êtes déconnecté.";
      }

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            automaticallyImplyLeading: true,
            title: const Text("",
              style: TextStyle(
                color: Colors.white,
              ),),
          ),
          backgroundColor: Colors.black12,
          body:
              ProgressHUD(
                child: Form(
                  key: globalFormKey,
                  child: _createAccountUI(context, message),
                ),
                inAsyncCall: isAPIcallProcess,
                opacity: 0.3,
                key: UniqueKey(),
              ),
        ),
      );
    }

    Widget _createAccountUI(BuildContext context, String message) {
      return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  "Inscription",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 60),
                child: Text(
                  "Veuillez saisir ces différentes informations afin que votre liste soit sauvegardée.",
                  textAlign: TextAlign.center,
                  style: TextStyle(

                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              FormHelper.inputFieldWidget(context, "nom", "                        Nom d'utilisateur",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Ce champ ne peut être vide";
                    }
                    return null;
                  }, (onSaved) {
                    nom = onSaved;
                  },
                  hintFontSize: 17.0,
                  backgroundColor: Colors.white10,
                  borderFocusColor: Colors.white10,
                  borderColor: Colors.black12,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.8),
                  borderRadius: 5
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: FormHelper.inputFieldWidget(
                  context,
                  "identifiant",
                  "                                   E-mail",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Ce champ ne peut être vide";
                    }
                    return null;
                  },
                      (onSaved) {
                    email = onSaved;
                  },
                  hintFontSize: 17.0,
                  backgroundColor: Colors.white10,
                    borderFocusColor: Colors.white10,
                    borderColor: Colors.black12,
                    textColor: Colors.white,
                    hintColor: Colors.white.withOpacity(0.8),
                    borderRadius: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: FormHelper.inputFieldWidget(
                  context,
                  "Mot_de_passe",
                  "                             Mot de passe",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Le mot de passe ne peut être vide";
                    }
                    mdp = onValidateVal;
                    return null;
                  },
                      (onSaved) {
                    mdp = onSaved;
                  },
                  hintFontSize: 17.0,
                  backgroundColor: Colors.white10,
                    borderFocusColor: Colors.white10,
                    borderColor: Colors.black12,
                    textColor: Colors.white,
                    hintColor: Colors.white.withOpacity(0.8),
                    borderRadius: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: FormHelper.inputFieldWidget(
                  context,
                  "check_Mot_de_passe",
                  "              Vérification du mot de passe",
                      (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Le mot de passe ne peut être vide";
                    }
                    if (onValidateVal != mdp ){

                      return  " Les mots de passe sont différents !";
                    }
                    return null;
                  },
                      (onSaved) {
                    checkMdp = onSaved;
                  },
                  hintFontSize: 17.0,
                  backgroundColor: Colors.white10,
                  borderFocusColor: Colors.white10,
                  borderColor: Colors.black12,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.8),
                  borderRadius: 5,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: FormHelper.submitButton(" S'inscrire", () {
                  dynamic validate = globalFormKey.currentState?.validate();
                  if (validate != null && validate) {
                    globalFormKey.currentState?.save();
                    UserDAO.CreateAccount(context, nom, email, mdp);
                  }
                },
                    fontSize: 17.0,
                    width:355.0,
                    btnColor: Colors.deepPurpleAccent,
                    borderColor: Colors.deepPurpleAccent,
                    txtColor: Colors.white,
                    borderRadius: 5),
              )
            ]),
      );
    }
}
