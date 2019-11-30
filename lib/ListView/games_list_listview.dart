import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/score_label.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';
import 'package:shelem_shomar/models/game_table.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/pages/recover_last_games.dart';

class GamesListListView extends StatefulWidget {
  final List<GameTable> games;

  GamesListListView(this.games);

  @override
  State<StatefulWidget> createState() {
    return _GamesListView();
  }
}

class _GamesListView extends State<GamesListListView> {
  String name1;

  Future<String> getPlayerName(int id) async {
    var db = DBHelper();
    PlayerTable player = await db.getPlayer(id: id);
    return player.name;
  }

  Future<String> getPlayerAvatar(int id) async {
    var db = DBHelper();
    PlayerTable player = await db.getPlayer(id: id);
    return player.avatar;
  }

  FutureBuilder _returnName(int index) {
    return FutureBuilder<String>(
      future: getPlayerName(index), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text(S.of(context).refreshPage);
          case ConnectionState.waiting:
            return new Text('${S.of(context).loading}...');
          default:
            if (snapshot.hasError)
              return null;
            else
              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: new Text(
                    '${snapshot.data}',
                    softWrap: false,
                    style: TextStyle(fontSize: 18.0),
                  ));
        }
      },
    );
  }

  FutureBuilder _returnAvatar(int index) {
    return FutureBuilder<String>(
      future: getPlayerAvatar(index), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text(S.of(context).refreshPage);
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasError)
              return null;
            else
              return CustomCircleAvatar(
                snapshot.data,
                radius: 20.0,
                iconSize: 25.0,
                circleColor: Theme.of(context).accentColor,
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.games.isEmpty) {
      return Center(
        child: Text(
          S.of(context).thereIsNoGameHere,
          style: TextStyle(fontSize: 26.0),
        ),
      );
    }

    String languageCode = Localizations
        .localeOf(context)
        .languageCode;

    return new ListView.builder(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecoverLastGames(widget.games[index]),
                ));
          },
          child: Card(
            color: Theme.of(context).cardColor,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _returnAvatar(
                                        widget.games[index].player1Id),
                                    _returnAvatar(
                                        widget.games[index].player2Id),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                _returnName(widget.games[index].player1Id),
                                _returnName(widget.games[index].player2Id),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                TextWithLocale(
                                    widget.games[index].date, languageCode),
                                TextWithLocale(
                                    widget.games[index].time, languageCode),
                                ScoreLabel(
                                  widget.games[index].team1Points.toString() +
                                      ' : ' +
                                      widget.games[index].team2Points
                                          .toString(),
                                  width: 100.0,
                                  fontSize: 16.0,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _returnAvatar(
                                        widget.games[index].player3Id),
                                    _returnAvatar(
                                        widget.games[index].player4Id),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                _returnName(widget.games[index].player3Id),
                                _returnName(widget.games[index].player4Id),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: widget.games.length,
    );
  }
}
