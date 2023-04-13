import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_videogames/UserAguments.dart';
import 'package:my_videogames/gameDAO.dart';
import 'package:my_videogames/userDao.dart';
import 'package:my_videogames/connexion.dart';


import 'gameDetail.dart';

class AffichageDetailGame extends StatefulWidget {
  const AffichageDetailGame({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AffichageDetailGameState();
}

class _AffichageDetailGameState extends State<AffichageDetailGame> {
  Icon customIconWhislist = const Icon(Icons.star_border);
  Icon customIconLike = const Icon(Icons.favorite_border);

  Widget wishBar = const Text(
    'Ma liste de souhaits',
    style: TextStyle(
      color: Colors.white,
    ),
  );

  Widget likedBar = const Text(
    'Mes likes',
    style: TextStyle(
      color: Colors.white,
    ),
  );

  Widget detailGameBar = const Text(
    "Détail du jeu",
    style: TextStyle(
      color: Colors.white,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool visibilityDescription = false;
  bool visibilityAvis = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "description") {
        visibilityDescription = visibility;
      }
      if (field == "avis") {
        visibilityAvis = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserArguments userArguments =
        ModalRoute.of(context)!.settings.arguments as UserArguments;

    GameDetail? gd = userArguments.gd;
    Connexion? connexion = userArguments.connexion;
    List<int>? wishlist = userArguments.wishlist;
    List<int>? likelist = userArguments.likelist;
    late Future<List> _avis = GameDAO.getGameListAvis(gd.appid);
    setState(() {
      _avis = _avis.then<List>((value) {
        for (var el in value) {
          print('avis value  : ${el.review}');
        }
        return value;
      });
    });

    String message = "";
    var gameDescription = gd.shortDescription;
    Widget description = Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Text(
          gameDescription,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
    Widget avis = Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 900.0,
          child: FutureBuilder<List>(
            future: _avis,
            builder: (context, snapshot) {
              print(' avis--- snapshot.hasData : ${snapshot.hasData}');
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      " Chargement des données.\n Merci de patienter.",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, i) {
                        String review=snapshot.data![i].review.toString();
                        String joueur = 'id joueur : ' + snapshot.data![i].steamid.toString();
                        String note = (snapshot.data![i].weighted_vote_score * 5).toStringAsFixed(0) +'/5';
                        print('snapshot.data![i]-- avis : ${snapshot.data![i]}');
                        if (snapshot.data![i] == null) {
                        i++;
                        }
                       if (review == "Aucun avis") {
                         joueur = "";
                         note = "Aucune note";

                       }

                        return Card(
                          color: Colors.black54,
                          child: ListTile(
                              title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 80.0, bottom: 10.0),
                                            child: Text(
                                              joueur,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.only(left: 30.0),
                                            child: Text(note,
                                              softWrap: false,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.yellowAccent,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ]),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      review,
                                      softWrap: true,
                                      //maxLines: 100,
                                      //overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )

                              // ]),
                              //]),
                              ),
                        );
                      });
                }
                ;
              } else {
                return const Center(
                  child: Text(
                    " Oups... problème de chargement des données.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              ;
            },
          ),
        ),
      ),
    );

    String content = gd.shortDescription;
    setState(() {});

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          automaticallyImplyLeading: true,
          title: const Text(
            "Détails du jeu",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: customIconWhislist,
              onPressed: () {
                setState(() {
                  message = "jeu ajouté à votre whislist";
                  if (customIconWhislist.icon == Icons.star_border) {
                    customIconWhislist = const Icon(Icons.star);
                    //print('connexion.email: ${connexion.email}');
                    var exist = false;
                    for (var element in wishlist) {
                      if (element == gd.appid) {
                        exist = true;
                      }
                    }
                    if (!exist) {
                      wishlist.add(gd.appid);
                    }
                    UserDAO.addGameIdToUserWhishlist(
                        context, gd.appid, connexion);
                  } else {
                    customIconWhislist = const Icon(
                      Icons.star_border,
                      color: Colors.white,
                    );
                  }
                });
              },
            ),
            IconButton(
              icon: customIconLike,
              onPressed: () {
                setState(() {
                  if (customIconLike.icon == Icons.favorite_border) {
                    customIconLike = const Icon(Icons.favorite);
                    print('connexion.email: ${connexion.email}');
                    var exist = false;
                    for (var element in likelist) {
                      if (element == gd.appid) {
                        exist = true;
                      }
                    }
                    if (!exist) {
                      likelist.add(gd.appid);
                    }

                    UserDAO.addGameIdToUserLikeList(
                        context, gd.appid, connexion);
                  } else {
                    customIconLike = const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    );
                  }
                });
              },
            ),
          ],
          centerTitle: true,
        ),
        body: Container(
            color: Colors.black87,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: Image(
                    image: AssetImage('assets/image01.jpg'),
                    height: 200,
                    //width: 200,
                  )),
                  Card(
                    margin: const EdgeInsets.only(
                        left: 15, bottom: 0, top: 0, right: 15),
                    color: Colors.black12,
                    child: Container(
                      // padding: const EdgeInsets.only(left: 10, bottom: 0, top: 0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: NetworkImage(gd.image),
                              height: 95,
                              width: 160,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 0, top: 25),
                                  child: Text(
                                    gd.name,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 25, top: 5),
                                  child: Text(
                                    'Editeur : ' + gd.publishers[0].toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                constraints: BoxConstraints.tight(
                                    const Size(190.00, 30.00)),
                                child: TextButton(
                                    //autofocus: visibilityDescription,
                                    child: Text('DESCRIPTION'),
                                    onPressed: () {
                                      // visibilityDescription = true;
                                      ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith<
                                                  Color>(
                                              (Set<MaterialState> states) {
                                        return Colors.deepPurpleAccent;
                                      }));
                                      setState(() {
                                        /*(Set<MaterialState> states) {
                                          MaterialState.focused;
                                        };*/
                                        _changed(false, "avis");
                                        _changed(true, "description");
                                        //visibilityAvis = false;
                                        //visibilityDescription = true;
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        if (states.contains(
                                                MaterialState.pressed) ||
                                            states.contains(
                                                MaterialState.focused)) {
                                          return Colors.deepPurpleAccent;
                                        }
                                        return Colors
                                            .black; // Use the component's default.
                                      }),
                                      foregroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          return Colors
                                              .white; // Use the component's default.
                                        },
                                      ),
                                      side: MaterialStateProperty.resolveWith<
                                              BorderSide>(
                                          (Set<MaterialState> states) {
                                        return const BorderSide(
                                            width: 1,
                                            color: Colors.deepPurpleAccent);
                                      }),
                                    ))),
                            Container(
                                constraints: BoxConstraints.tight(
                                    const Size(190.00, 30.00)),
                                child: OutlinedButton(
                                    // autofocus: visibilityAvis,
                                    style: ButtonStyle(foregroundColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>(
                                      (Set<MaterialState> states) {
                                        return Colors
                                            .white; // Use the component's default.
                                      },
                                    ), backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states.contains(
                                              MaterialState.pressed) ||
                                          states.contains(
                                              MaterialState.focused)) {
                                        return Colors.deepPurpleAccent;
                                      }
                                      return Colors
                                          .black; // Use the component's default.
                                    }), side: MaterialStateProperty.resolveWith<
                                            BorderSide>(
                                        (Set<MaterialState> states) {
                                      return const BorderSide(
                                          width: 1,
                                          color: Colors.deepPurpleAccent);
                                    })),
                                    onPressed: () {
                                      // visibilityAvis = true;
                                      setState(() {
                                        //visibilityDescription =false;
                                        //visibilityAvis = true;
                                        _changed(true, "avis");
                                        _changed(false, "description");
                                      });
                                    },
                                    child: const Text('AVIS'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      child: Text(message,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red))),
                  Expanded(
                    child: visibilityDescription
                        ? SizedBox(height: 500.0, child: description)
                        : visibilityAvis
                            ? avis
                            : Container(),
                  ),
                ])));
  }
}
