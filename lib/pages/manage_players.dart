import 'package:flutter/material.dart';
import 'package:shelem_shomar/ListView/manage_players_listview.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';

class ManagePlayers extends StatefulWidget {
  @override
  _ManagePlayersState createState() => _ManagePlayersState();
}

class _ManagePlayersState extends State<ManagePlayers> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).managePlayers),
      ),
      drawer: SideDrawer(),
      body: FutureBuilder(
        future: db.getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          var data = snapshot.data;

          return snapshot.hasData
              ? ManagePlayersListView(data)
              : Center(
                  child: Text(
                    S.of(context).addPlayerFirst,
                    style: TextStyle(fontSize: 26.0),
                  ),
                );
        },
      ),
//      body: futureBuilder,
    );
  }
}
