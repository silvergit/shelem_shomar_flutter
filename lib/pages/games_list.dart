import 'package:flutter/material.dart';
import 'package:shelem_shomar/ListView/games_list_listview.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';

class GamesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameListState();
  }
}

class _GameListState extends State<GamesList> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).gamesList),
      ),
      drawer: SideDrawer(),
      body: FutureBuilder(
        future: db.getAllGames(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          var data = snapshot.data;
          return snapshot.hasData
              ? GamesListListView(data)
              : Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme
                      .of(context)
                      .primaryColor),
              padding: EdgeInsets.all(48.0),
              margin: EdgeInsets.all(48.0),
              child: Text(
                S
                    .of(context)
                    .thereIsNoGameHere,
                style: TextStyle(
                    fontSize: 22.0, color: Theme
                    .of(context)
                    .canvasColor),
                textAlign: TextAlign.center,
              ),
                  ),
                );
        },
      ),
    );
  }
}
