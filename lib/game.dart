import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_videogames/gameDetail.dart';

class Game {
  final int rank;
  final int appid;
  final int lastWeekRank;
  final int peakInGame;

  const Game({
    required this.rank,
    required this.appid,
    required this.lastWeekRank,
    required this.peakInGame,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      rank: int.parse(json['rank']),
      appid: int.parse(json['appid']),
      lastWeekRank: int.parse(json['last_week_rank']),
      peakInGame: int.parse(json['peak_in_game']),
    );
  }

  static String baseUrl =
      "https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/?";

  static Future<List<dynamic>> getAllGames() async {
    try {
      final res = await http.get(Uri.parse(baseUrl + '/'));
      if (res.statusCode == 200) {
        List<dynamic> ranks =jsonDecode(res.body)['response']['ranks'];
        return ranks;
      } else {
        return Future.error("erreur serveur");
      }
    } catch (err) {
      return Future.error(err);
    }
  }


}
