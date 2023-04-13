import 'package:flutter/material.dart';
import 'UserAguments.dart';
import 'connexion.dart';
import 'gameDetail.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserArguments userArguments =
        ModalRoute.of(context)!.settings.arguments as UserArguments;
    GameDetail? gd = userArguments.gd;
    Connexion? connexion = userArguments.connexion;
    List<int>? wishlist = userArguments.wishlist;
    List<int>? likelist = userArguments.likelist;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('Recherche'),
          automaticallyImplyLeading:true,
          ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 320,
                  child: TextField(
                    controller: myController,
                    autofocus: true,
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, '/searchlist',
                        arguments: UserArguments(gd, connexion, wishlist,
                            likelist, myController.text.toString()));
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
