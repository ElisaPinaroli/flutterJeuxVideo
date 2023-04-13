import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'UserAguments.dart';
import 'connexion.dart';
import 'gameDetail.dart';

class UserDAO {
  static const baseUrl = 'http://192.168.56.1:5500/user';

  static CreateAccount(BuildContext context, nom, email, mdp) async {
    String messageError = "";

    try {
      Map data = {'nom': nom, 'email': email, 'mdp': mdp};
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(Uri.parse(baseUrl),
          headers: {"Content-Type": "application/json"}, body: body);
      print("response status : ${response.statusCode}");
      print("response body : ${response.body}");

      if (response.statusCode == 201) {
        // connexion à l'application
        var connexion = Connexion(email: email, mdp: mdp);
        var res = await http.get(Uri.parse(baseUrl + "/$email/$mdp"));
        print(res.statusCode);
        if (res.statusCode == 200) {
          //Navigator.pushNamed(context, '/home', arguments: connection);
          Navigator.pushNamed(context, '/home',
              arguments: UserArguments(
                  GameDetail(
                      name: "",
                      appid: 0,
                      image: "",
                      isFree: false,
                      publishers: [],
                      price: "",
                      shortDescription: "",
                      longDescription: ""),
                  connexion,
                  [],
                  [],
                  ""));
        } else {
          print("=============== KO");
          messageError = "Combinaison mot de passe/identifiant incorrect !";
          Navigator.pushNamed(context, '/', arguments: messageError);
        }
      } else {
        print("=============== KO");
        messageError =
            "une erreur est survenue. Votre compte n'a pas pu être créé.";
        Navigator.pushNamed(context, '/', arguments: messageError);
      }
    } catch (err) {
      return Future.error(err);
    }
  }
  static Map<String, String> customHeader = {
    "content-type": "application/json"
  };

  static Login(BuildContext context, email, mdp) async {
    String messageError = "";
    var wishlist = <int>[];
    var likelist = <int>[];
    try {
      var connexion = Connexion(email: email, mdp: mdp);
      var res = await http.get(Uri.parse(baseUrl + "/$email/$mdp"));
      print("=============== avant if ");
      print(res.statusCode);
      if (res.statusCode == 200) {
       // Navigator.pushNamed(context, '/home', arguments: connection);
        Future<List> _wishlist = UserDAO.getWishListIdsbyUser(connexion);
        _wishlist = _wishlist.then<List>((value) {
          for (var val in value) {
            print('val : ${val}');
            wishlist.add(val as int);
          }
          return value;
        });

        Future<List> _likelist = UserDAO.getLikeListIdsbyUser(connexion);
        _likelist = _likelist.then<List>((value) {
          for (var val in value) {
            print('val : ${val}');
            likelist.add(val as int);
          }
          return value;
        });

        Navigator.pushNamed(context, '/home',
            arguments: UserArguments(
                GameDetail(
                    name: "",
                    appid: 0,
                    image: "",
                    isFree: false,
                    publishers: [],
                    price: "",
                    shortDescription: "",
                    longDescription: ""),
                connexion,
                wishlist,
                likelist,
                ""));
      } else {
        print("=============== KO");
        messageError = "Combinaison mot de passe/email incorrect !";
        Navigator.pushNamed(context, '/', arguments: messageError);
      }
    } catch (err) {
      return Future.error(err);
    }
  }

  static addGameIdToUserWhishlist(BuildContext context, id, connexion) async {
    String messageError = "";
    String message = "";
    String email = connexion.email.toString();
    try {
      Map data = {
        'email': email,
        'mdp': connexion.mdp,
        'wishlist': id,
      };
      //encode Map to JSON
      var body = json.encode(data);
      print("body : ${body}");
      var response = await http.put(Uri.parse(baseUrl + "/wishlist/$email"),
          headers: {"Content-Type": "application/json"}, body: body);
      print("response status : ${response.statusCode}");
      print("response body : ${response.body}");

      if (response.statusCode == 200) {
        message = "Jeu ajouté à votre  wishlist";
       // Navigator.pushNamed(context, '/details-game', arguments: message);
      } else {
        print("=============== KO");
        messageError = "erreur";
      }
    } catch (err) {
      return Future.error(err);
    }
  }

  static addGameIdToUserLikeList(BuildContext context, id, connexion) async {
    String messageError = "";
    String message = "";
    String email = connexion.email.toString();
    try {
      Map data = {
        'email': email,
        'mdp': connexion.mdp,
        'likelist': id,
      };
      //encode Map to JSON
      var body = json.encode(data);
      print("body : ${body}");
      var response = await http.put(Uri.parse(baseUrl + "/likelist/$email"),
          headers: {"Content-Type": "application/json"}, body: body);
      print("response status : ${response.statusCode}");
      print("response body : ${response.body}");

      if (response.statusCode == 200) {
        message = "Jeu ajouté à votre likelist";
       // Navigator.pushNamed(context, '/details-game', arguments: message);
      } else {
        print("=============== KO");
        messageError = "erreur";
      }
    } catch (err) {
      return Future.error(err);
    }
  }

  // récupérer les ids des jeux de la BDD
  static Future <List> getWishListIdsbyUser(connexion) async {
    String email = connexion.email.toString();
    String mdp = connexion.mdp.toString();
    try {
      var response = await http.get(Uri.parse(baseUrl + "/wishlist/$email/$mdp"));

      if (response.statusCode == 200) {
        print('body : ${jsonDecode(response.body)}');
        List ids = jsonDecode(response.body) ;

        return ids;
      } else {
    return Future.error("erreur serveur");
    }
    } catch (err) {
      return Future.error(err);
    }
  }

  static Future <List> getLikeListIdsbyUser(connexion) async {
    String email = connexion.email.toString();
    String mdp = connexion.mdp.toString();
    try {
      var response = await http.get(Uri.parse(baseUrl + "/likelist/$email/$mdp"));

      if (response.statusCode == 200) {
        print('body : ${jsonDecode(response.body)}');
        List ids = jsonDecode(response.body);
        return ids;
      } else {
        return Future.error("erreur serveur");
      }
    } catch (err) {
      return Future.error(err);
    }
  }



}
