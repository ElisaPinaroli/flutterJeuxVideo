import 'package:flutter/cupertino.dart';

class Connexion {
  String email;
  String mdp;

  Connexion({
    required this.email,
    required this.mdp,
  });

  clearConnexion() {
    return Connexion(email: "", mdp:"");
  }

  static Connexion initializeConnexion(futureConnexion) {
    try {
      return futureConnexion as Connexion;
    } catch (err) {
      ErrorDescription("cast impossible");
      return Connexion(email: " ", mdp: " ");
    }
  }

  factory Connexion.fromJson(Map<String, dynamic> json) {
    return Connexion(
      email: json['email'],
      mdp: json['mdp'],
    );
  }
}
