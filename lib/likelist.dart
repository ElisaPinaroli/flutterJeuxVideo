import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_videogames/gameDAO.dart';
import 'UserAguments.dart';
import 'connexion.dart';
import 'gameDetail.dart';

class AffichageLikeList extends StatefulWidget {
  const AffichageLikeList({Key? key}) : super(key: key);

  @override
  State<AffichageLikeList> createState() => _AffichageLikeListState();
}

class _AffichageLikeListState extends State<AffichageLikeList> {
  late Future<List> _gameLikelist; // type dynamic

  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserArguments userArguments = ModalRoute.of(context)!.settings.arguments as UserArguments;
    Connexion? connexion = userArguments.connexion;
    List<int>? wishlist = userArguments.wishlist;
    List<int>? likelist = userArguments.likelist;
    print('email: ${connexion.email}');


    setState(()  {
      print('likelist: ${likelist}');
      _gameLikelist = GameDAO.fetchGetAllGamesDetails(likelist);
      _gameLikelist.whenComplete(() {
        print('OK');
         _gameLikelist =  _gameLikelist.then<List>((values) {
          return  values;

        });
      });
    });
    if (likelist.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('Mes likes'),
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black54,
          child: FutureBuilder<List>(
            future: _gameLikelist,
            builder: (context, snapshot) {
              print('snapshot : ${snapshot.hasData}');
              String price = '';
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      // int id = snapshot.data![i]['steam_appid'];
                      if (snapshot.data![i]['price_overview'] == null) {
                        price = '0 €';
                      } else {
                        //price = snapshot.data![i]['price_overview']['initial'];
                        price = snapshot.data![i]['price_overview']
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
                                      image: NetworkImage(
                                          snapshot.data![i]['header_image']),
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
                                          snapshot.data![i]['name'],
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
                                              snapshot.data![i]['publishers'][0]
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
                                                    likelist,""));
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
    }else{
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: const Text('Mes likes'),
            automaticallyImplyLeading: true,
            centerTitle: true,
          ),
          body: Container(
            color: Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(
                    child: const Image(
                      image: AssetImage('assets/heart.png'),
                      height: 200,
                      width: 200,
                    )),
                Container(
                  padding: const EdgeInsets.all(70),
                  child: const Text(
                      "Votre liste de likes est vide.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
