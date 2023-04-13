import 'package:flutter/material.dart';
import 'package:my_videogames/affichageDetailGame.dart';
import 'package:my_videogames/createAccount.dart';
import 'package:my_videogames/affichageGame.dart';
import 'package:my_videogames/likelist.dart';
import 'package:my_videogames/search.dart';
import 'package:my_videogames/searchbar.dart';
import 'package:my_videogames/wishList.dart';
import 'login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jeux Video',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),

        routes: {
          '/': (context) => LoginPage(),
          '/home':(context) => AffichageGame(),
          '/create-account': (context) => CreateAccount(),
          '/details-game': (context) => AffichageDetailGame(),
          '/wishlist': (context) => AffichageWishList(),
          '/likelist': (context)=> AffichageLikeList(),
          '/searchlist' : (context)=> AffichageSearchList(),
          '/search' : (context) => SearchForm()
        }
        //home: const MyHomePage(title: 'Home Page'),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(
             'Bienvenue',
           ),
         ],
       ),
      ),
    );
  }
}
