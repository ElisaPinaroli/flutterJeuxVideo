import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_videogames/game.dart';
import 'package:my_videogames/gameDAO.dart';
import 'UserAguments.dart';
import 'gameDetail.dart';
import 'connexion.dart';

class AffichageGame extends StatefulWidget {
  const AffichageGame({Key? key}) : super(key: key);

  @override
  State<AffichageGame> createState() => _AffichageGameState();
}

class _AffichageGameState extends State<AffichageGame> {
  late Future<List> _gameList; // type dynamic
  late Future<List> _futureGameDetail; // type dynamic

  GameDAO gdao = new GameDAO();
  var games = <Game>[];
  var gamesIds = <int>[];
  var futureGameDetail = <GameDetail>[];

  Icon upload = const Icon(Icons.upload);
  Icon customIcon = const Icon(Icons.search);
  Icon customIconWishList = const Icon(Icons.star_border);
  Icon customIconLike = const Icon(Icons.favorite_border);
  Widget searchBar = const Text(
    'Accueil',
    style: TextStyle(
      color: Colors.white,
    ),
  );

  @override
  void initState() {
    super.initState();
    _gameList = Game.getAllGames();
    _gameList.whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

      UserArguments userArguments =
          ModalRoute.of(context)!.settings.arguments as UserArguments;
      GameDetail? gd = userArguments.gd;
      Connexion ? connexion = userArguments.connexion;
      List<int>? wishlist = userArguments.wishlist;
      List<int>? likelist = userArguments.likelist;

      setState(() {
      _gameList = _gameList.then((value) {
        for (var el in value) {
          print('el : ${el['appid']}');
          gamesIds.add(el['appid']);
        }
        return value;
      });

      print('gamesIds : ${gamesIds}');
      _futureGameDetail = GameDAO.fetchGetAllGamesDetails(gamesIds);
      _futureGameDetail = _futureGameDetail.then<List>((value) {
        return value;
      });

    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text("Accueil",
          style: TextStyle(fontFamily: 'GoogleSans',
              fontStyle: FontStyle.normal
          ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: customIconWishList,
              onPressed: () {
                // affichage de la wihslist
                Navigator.pushNamed(context, '/wishlist',
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
              },
            ),
            IconButton(
              icon: customIconLike,
              onPressed: () {
                //Affichage de la listes des jeux likés
                Navigator.pushNamed(context, '/likelist',
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
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search',
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
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              icon: upload,
              onPressed: () {
                setState(() {});
              },
            ),
            IconButton(
              onPressed: () => {
                Navigator.pushNamed(context, '/',
                    arguments: connexion.clearConnexion())
              },
              icon: new Icon(Icons.logout),
            ),
          ],
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black54,
          child: FutureBuilder<List>(
            future: _futureGameDetail,
            builder: (context, snapshot) {
              print('snapshot has data : ${snapshot.hasData}');
              String price = '';

              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      " Chargement des données.\n Merci de patienter.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, i) {
                        print('snapshot.data![i] : ${snapshot.data![i]}');
                        if (snapshot.data![i]! == false ||
                            snapshot.data![i]!.isEmpty) {
                          i++;
                        }
                        if (snapshot.data![i]!['price_overview'] == null) {
                          price = '0 €';
                        } else {
                          //price = snapshot.data![i]['price_overview']['initial'];
                          price = snapshot.data![i]!['price_overview']
                              ['final_formatted'];
                        }
                        return Card(
                          color: Colors.black54,
                          child: ListTile(
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(children: [
                                    Container(
                                      child: Image(
                                          image: NetworkImage(snapshot.data![i]
                                              ['header_image']),
                                          height: 100,
                                          width: 90),
                                    ),
                                  ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints.tight(
                                              const Size(183.00, 30.00)),
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            snapshot.data![i]!['name'],
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          //constraints: BoxConstraints.tight(const Size(160.00,30.00)),
                                          child: Text(
                                            'Editeur : ' +
                                                snapshot.data![i]!['publishers']
                                                        [0]
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            'Prix : ' + price,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ]),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        //color: Colors.deepPurpleAccent,
                                        //padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.deepPurpleAccent,
                                              onPrimary: Colors.white,
                                            ),
                                            onPressed: () {
                                              GameDetail gd = GameDetail(
                                                  name: snapshot
                                                      .data![i]!['name'],
                                                  appid: snapshot.data![i]
                                                      ['steam_appid'],
                                                  image: snapshot.data![i]
                                                      ['header_image'],
                                                  isFree: snapshot.data![i]
                                                      ['is_free'],
                                                  publishers: snapshot.data![i]
                                                      ['publishers'],
                                                  price: price,
                                                  shortDescription:
                                                      snapshot.data![i]
                                                          ['short_description'],
                                                  longDescription: snapshot
                                                          .data![i]
                                                      ['detailed_description']);
                                              Navigator.pushNamed(
                                                  context, '/details-game',
                                                  arguments: UserArguments(
                                                      gd,
                                                      connexion,
                                                      wishlist,
                                                      likelist,
                                                      ""));
                                            },
                                            child: const Text('Voir')),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        );
                      });
                }
              } else {
                return const Center(
                  child: Text(
                    " Oups... problème de chargement des données. \n Cliquez sur l'icone 'upload'.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }
}
