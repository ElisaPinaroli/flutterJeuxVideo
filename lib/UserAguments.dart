
import 'package:my_videogames/connexion.dart';
import 'package:my_videogames/gameDetail.dart';

class UserArguments {
  GameDetail gd;
  Connexion connexion;
  List<int> wishlist;
  List<int> likelist;
  String searchterm;

  UserArguments(this.gd, this.connexion, this.wishlist, this.likelist, this.searchterm);
}