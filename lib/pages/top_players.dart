import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _listGridTypeIndex;

  void _updateListGridTypeIndex() {
    int maxIndex = 1;
    if (_listGridTypeIndex + 1 > maxIndex)
      setState(() {
        _listGridTypeIndex = 0;
      });
    else
      setState(() {
        _listGridTypeIndex++;
      });
    _saveSharedPreferences();
  }

  void _saveSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('listGridTypeTopPlayers', _listGridTypeIndex);
  }

  void _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('listGridTypeTopPlayers') != null) {
      setState(() {
        _listGridTypeIndex = prefs.getInt('listGridTypeTopPlayers');
      });
    } else {
      setState(() {
        _listGridTypeIndex = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).topPlayers),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.line_style), onPressed: _updateListGridTypeIndex)
        ],
      ),
      drawer: SideDrawer(),
      body: FutureBuilder(
        future:
            Future.wait([db.getPlayers(), db.getAllGames(), db.getWinLooses()])
                .then(
                  (response) =>
              new CollectAllData(
              players: response[0], games: response[1], states: response[2]),
        ),
        builder: (context, AsyncSnapshot<CollectAllData> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          var data = snapshot.data;

          return snapshot.hasData
              ? TopPlayersListView(data, _listGridTypeIndex)
              : Center(
                  child: Text(
                    S.of(context).addPlayersAndPlayGamesFirst,
                    style: TextStyle(fontSize: 16.0),
                  ),
                );
        },
      ),
    );
  }
}

class CollectAllData {
  List<WinLossTable> states;
  List<GameTable> games;
  List<PlayerTable> players;

  CollectAllData({this.players, this.states, this.games});
}
