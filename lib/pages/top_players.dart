import 'package:flutter/material.dart';
import 'package:shelem_shomar/ListView/top_players_listview.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';
import 'package:shelem_shomar/models/game_table.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/models/win_loss_table.dart';

class TopPlayers extends StatefulWidget {
  @override
  _TopPlayersState createState() => _TopPlayersState();
}

class _TopPlayersState extends State<TopPlayers> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).topPlayers),
      ),
      drawer: SideDrawer(),
      body: FutureBuilder(
        future:
            Future.wait([db.getPlayers(), db.getAllGames(), db.getWinLooses()])
                .then(
          (response) => new CollectAllDatas(
              players: response[0], games: response[1], states: response[2]),
        ),
        builder: (context, AsyncSnapshot<CollectAllDatas> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          var data = snapshot.data;

          return snapshot.hasData
              ? TopPlayersListView(data)
              : Center(
                  child: Text(
                    S.of(context).addPlayersAndPlayGamesFirst,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
        },
      ),
    );
  }
}

class CollectAllDatas {
  List<WinLossTable> states;
  List<GameTable> games;
  List<PlayerTable> players;

  CollectAllDatas({this.players, this.states, this.games});
}
