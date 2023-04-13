import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_videogames/gameDAO.dart';
import 'UserAguments.dart';
import 'connexion.dart';
import 'gameDetail.dart';


class AffichageSearchList extends StatefulWidget {
  const AffichageSearchList({Key? key}) : super(key: key);

  @override
  State<AffichageSearchList> createState() => _AffichageSearchListState();
}

class _AffichageSearchListState extends State<AffichageSearchList> {
  late Future<List> _gameSearchlist; // type dynamic


  @override

  void initState() {
    super.initState();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    UserArguments userArguments = ModalRoute.of(context)!.settings.arguments as UserArguments;

    Connexion? connexion = userArguments.connexion;
    List<int>? wishlist = userArguments.wishlist;
    List<int>? likelist = userArguments.likelist;
    String ? searchterm = userArguments.searchterm;



    print('email: ${connexion.email}');
    setState(() {
      _gameSearchlist = GameDAO.getAllGameDetailsBySearch(searchterm);
      _gameSearchlist.whenComplete(() {
        print('OK');
        _gameSearchlist = _gameSearchlist.then<List>((values) {
          return values;
        });
      });
    });

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('Recherche'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
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
              },
              icon: Icon (Icons.clear),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search', arguments:  UserArguments(
                    GameDetail(name: "", appid: 0,image: "", isFree: false, publishers:[], price: "", shortDescription: "", longDescription: ""),
                    connexion, wishlist, likelist, ""));
              },
              icon: Icon (Icons.search),
            ),
        ],
        ),
        body:
        Container(
          color: Colors.black54,
          child: FutureBuilder<List>(
            future: _gameSearchlist,
            builder: (context, snapshot) {
              print('snapshot : ${snapshot.hasData}');
              String price = '';
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      // int id = snapshot.data![i]['steam_appid'];
                      if (snapshot.data![i]== null || snapshot.data![i]! == false ) {
                        i++;
                      }else {
                        if (snapshot.data![i]!['price_overview'] == null) {
                          price = '0 €';
                        } else {
                          //price = snapshot.data![i]['price_overview']['initial'];
                          price = snapshot.data![i]!['price_overview']
                          ['final_formatted'];
                        }
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
                                      image: NetworkImage(
                                          snapshot.data![i]!['header_image']),
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ]),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
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
                                        child: Text(
                                          'Editeur : ' +
                                              snapshot.data![i]!['publishers'][0]
                                                  .toString(),
                                          softWrap: true,
                                          maxLines:2 ,
                                          overflow: TextOverflow.fade,

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
                                                name: snapshot.data![i]['name'],
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
                                                arguments:
                                                UserArguments(
                                                    gd, connexion, wishlist,
                                                    likelist, ""));
                                          },
                                          child: const Text('Voir')),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                        // ]),
                      );
                    });
              } else {
                return const Center(
                  child: Text("Chargement en cours ..."),
                );
              }
              ;
            }, //builder
          ),

        ),
    );
  }
}
