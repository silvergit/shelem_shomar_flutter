import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shelem_shomar/ListView/manage_players_listview.dart';
import 'package:shelem_shomar/Widgets/empty_db_pages.dart';
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
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return SpinKitDoubleBounce(
                color: Theme
                    .of(context)
                    .accentColor,
                size: 56.0,
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              return snapshot.data.length > 0
                  ? ManagePlayersListView(snapshot.data)
                  : EmptyDbPages(text: S
                  .of(context)
                  .addPlayerFirst);
              break;
          }
          return Center(
            child: Text(
              S
                  .of(context)
                  .addPlayerFirst,
              style: TextStyle(fontSize: 26.0),
            ),
          );
        },
      ),
//      body: futureBuilder,
    );
  }
}
