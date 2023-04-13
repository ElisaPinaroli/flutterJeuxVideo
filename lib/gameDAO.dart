import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_videogames/gameAppreviews.dart';

class GameDAO {
  static String gameUrl =
      "https://store.steampowered.com/api/appdetails?lang=french&appids=";
  static String avisUrl = "https://store.steampowered.com/appreviews/";

  static String searchUrl =
      "https://store.steampowered.com/search/results/?json=1&query&dynamic_data=&sort_by=_ASC&snr=1_7_7_230_7&supportedlang=french&term=";
  static Map<String, String> customHeader = {
    "content-type": "application/json"
  };

  static Future<List> getGameListAvis(id) async {
    List reviews = [];
    try {
      final response = await http
          .get(Uri.parse(avisUrl + '$id' + '?language=french&json=1'));
      print(' response_avis : $id -   ${response.body}');

      List data =
          jsonDecode((response.body))['reviews']; // renvoie une liste de Json

      print('data: $data');

      if (response.statusCode == 200) {
        if (data.isEmpty) {
          reviews.add(GameAppreview(
              steamid: "",
              votes_up: 0,
              votes_funny: 0,
              review: "Aucun avis",
              weighted_vote_score: 0));
        } else {
          for (var el in data) {
            reviews.add(GameAppreview(
                steamid: el['author']['steamid'],
                votes_up: int.parse((el['votes_up']).toString()),
                votes_funny: int.parse((el['votes_funny']).toString()),
                review: el['review'],
                weighted_vote_score:
                    double.parse((el['weighted_vote_score']).toString())));
          }
        }
      }
      return reviews;
    } catch (err) {
      return Future.error(err);
    }
  }

  static Future<List> fetchGetAllGamesDetails(List<int> ids) async {
    List data = [];
    int long = ids.length;
    if (long > 50) {
      long = 50;
    }
    ;

    try {
      for (int i = 0; i < long; i++) {
        print('id : ${ids[i]}');

        final res = await http.get(Uri.parse(gameUrl + ids[i].toString()));
        if (res != null) {
          print(' res : ${res.body}');
        }
        if (res.statusCode == 200) {
          data.add(jsonDecode(res.body)[ids[i].toString()]['data']);
        }

        print('data : ${data}');
      }
      return data;
    } catch (err) {
      return Future.error(err);
    }
  }

  static Future<List> getAllGameDetailsBySearch(String searchterm) async {
    List<int> searchIds = [];
    var id;

    try {
      final response = await http.get(Uri.parse(searchUrl + searchterm));
      print(' response_search : $searchterm -   ${response.body}');
      List data =
          jsonDecode((response.body))['items']; // renvoie une liste de Json

      print('data recherche: $data');

      if (response.statusCode == 200) {
        for (var el in data) {
          List url_decoupe = el['logo'].split('/');
          print('url_decoupe: $url_decoupe');
          id = url_decoupe[5];
          print('id search: $id');
          searchIds.add(int.parse(id));
        }
      }
      return fetchGetAllGamesDetails(searchIds);
    } catch (err) {
      return Future.error(err);
    }
  }
}
