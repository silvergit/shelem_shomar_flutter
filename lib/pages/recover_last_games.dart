import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelem_shomar/ListView/chart_listview_last_games.dart';
import 'package:shelem_shomar/Widgets/bottom-bar-ingame.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';
import 'package:shelem_shomar/models/game_table.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/models/points_table.dart';

class RecoverLastGames extends StatefulWidget {
  final GameTable game;
  final int team1Points;
  final int team2Points;

  RecoverLastGames(this.game, this.team1Points, this.team2Points);

  @override
  State<StatefulWidget> createState() {
    return _RecoverLastGamesState();
  }
}

class _RecoverLastGamesState extends State<RecoverLastGames> {
  List<PlayerTable> players = [];

  int _listTypeIndex;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  void _updateListTypeIndex() {
    int maxIndex = 2;
    if (_listTypeIndex + 1 > maxIndex)
      setState(() {
        _listTypeIndex = 0;
      });
    else
      setState(() {
        _listTypeIndex++;
      });
    _saveSharedPreferences();
  }

  void _saveSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('listTypeLastGames', _listTypeIndex);
  }

  void _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('listTypeLastGames') != null) {
      setState(() {
        _listTypeIndex = prefs.getInt('listTypeLastGames');
      });
    } else {
      setState(() {
        _listTypeIndex = 0;
      });
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Theme.of(context).accentColor,
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                '${S.of(context).finalPoints}: ',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                widget.game.gameType.toString(),
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
        Text(
          widget.game.time,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 16.0,
        ),
        Text(
          widget.game.date,
          style: TextStyle(fontSize: 16.0),
        ),
      ]),
    );
  }

  Future<PlayerTable> getPlayer(int id) async {
    var db = DBHelper();
    PlayerTable player = await db.getPlayer(id: id);

    return player;
  }

  Widget widgetCircleAvatar(int id) {
    return FutureBuilder<PlayerTable>(
      future: getPlayer(id), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<PlayerTable> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) return Icon(Icons.error);
            return CustomCircleAvatar(
              snapshot.data.avatar,
              radius: 20.0,
              iconSize: 25.0,
            );
        }
        return null; // unreachable
      },
    );
  }

  Future<List<PlayerTable>> getPlayers() async {
    var db = DBHelper();
    PlayerTable p1 = await db.getPlayer(id: widget.game.player1Id);
    PlayerTable p2 = await db.getPlayer(id: widget.game.player2Id);
    PlayerTable p3 = await db.getPlayer(id: widget.game.player3Id);
    PlayerTable p4 = await db.getPlayer(id: widget.game.player4Id);

    List<PlayerTable> players = [p1, p2, p3, p4];

    return players;
  }

  Future<List<PointsTable>> getPoints() async {
    var db = DBHelper();

    List<PointsTable> points = await db.getpoints(widget.game.id);

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(S.of(context).gameChart),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.line_style), onPressed: _updateListTypeIndex)
        ],
      ),
      drawer: SideDrawer(),
      body: Column(
        children: <Widget>[
          _buildHeader(context),
          Expanded(
            child: FutureBuilder(
              future: Future.wait([getPlayers(), getPoints()]).then(
                (response) =>
                    new Merged(players: response[0], points: response[1]),
              ),
              builder: (context, AsyncSnapshot<Merged> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text(S.of(context).playAGameFirst);
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            S.of(context).loadingData,
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ],
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('${S.of(context).error}: ${snapshot.error}');
                    return ChartListViewLastGames(snapshot.data.players,
                        snapshot.data.points, _listTypeIndex);
                }
                return null; // unreachable
              },
            ),
          ),
//          _buildBottomResultsBar(),
        ],
      ),
      bottomNavigationBar: BottomBarInGame(_buildBottomResultsBar()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Color(0xFFF17532),
          child: Icon(Icons.close)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomResultsBar() {
    String languageCode = Localizations
        .localeOf(context)
        .languageCode;
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextWithLocale(
              widget.team1Points.toString(), languageCode, fontSize: 22.0,
              fontColor: Theme
                  .of(context)
                  .textTheme
                  .body1
                  .color,),
            TextWithLocale(
              widget.team2Points.toString(), languageCode, fontSize: 22.0,)
          ],
        ),
      ),
    );
  }

//  Widget _buildBottomResultsBar(String languageCode) {
//    return Container(
//      padding: EdgeInsets.all(10.0),
//      child: Row(
//        children: <Widget>[
//          CustomCircleAvatar(
//            _t1p1.avatar,
//            radius: 20.0,
//            iconSize: 25.0,
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
//          CustomCircleAvatar(
//            _t1p2.avatar,
//            radius: 20.0,
//            iconSize: 25.0,
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
//          Expanded(
//            child: TextWithLocale(
//              _team1PointsResult,
//              languageCode,
//              textAlignEn: TextAlign.start,
//              textAlignFa: TextAlign.end,
//              fontSize: 20.0,
//            ),
//          ),
//          Expanded(
//            child: TextWithLocale(
//              _team2PointsResult,
//              languageCode,
//              textAlignEn: TextAlign.end,
//              textAlignFa: TextAlign.start,
//              fontSize: 20.0,
//            ),
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
//          CustomCircleAvatar(
//            _t2p1.avatar,
//            radius: 20.0,
//            iconSize: 25.0,
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
//          CustomCircleAvatar(
//            _t2p2.avatar,
//            radius: 20.0,
//            iconSize: 25.0,
//          ),
//        ],
//      ),
//    );
//  }
}

class Merged {
  final List<PlayerTable> players;
  final List<PointsTable> points;

  Merged({this.players, this.points});
}
