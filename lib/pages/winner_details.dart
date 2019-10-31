import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/score_label.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/pages/in_game.dart';

class WinnerDetails extends StatefulWidget {
  final List<PlayerReadRecords> playerReadRecords;
  final int winner;
  final int length;
  final int dPosCount;
  final int dNegCount;
  final int team1Points;
  final int team2Points;
  final String gameTime;

  WinnerDetails(
      this.playerReadRecords,
      this.winner,
      this.length,
      this.dPosCount,
      this.dNegCount,
      this.team1Points,
      this.team2Points,
      this.gameTime);

  @override
  _WinnerDetailsState createState() => _WinnerDetailsState();
}

class _WinnerDetailsState extends State<WinnerDetails>
    with SingleTickerProviderStateMixin {
  String getMaxRead() {
    int maxRead = 0;
    for (PlayerReadRecords p in widget.playerReadRecords) {
      if (maxRead < p.topRead) {
        maxRead = p.topRead;
      }
    }
    if (maxRead == 999)
      return (S.of(context).kons);
    else if (maxRead == 998)
      return (S.of(context).shelem);
    else
      return maxRead.toString();
  }

  String getStringRead(int readPoints) {
    if (readPoints == 999)
      return (S.of(context).kons);
    else if (readPoints == 998)
      return (S.of(context).shelem);
    else
      return '  ' + readPoints.toString() + '   ';
  }

  int getPlayerScore(PlayerReadRecords player) {
    int score = 0;
    int handsNumber = widget.length;
    int wins = player.wins;
    int looses = player.looses;

    score = (wins * 2) + (looses * -1);
    score = ((score / handsNumber) * 10).round();

    return score;
  }

  Map<String, String> getWinners() {
    Map<String, String> result;
    if (widget.winner == 1) {
      result = {
        'name1': widget.playerReadRecords[0].name,
        'avatar1': widget.playerReadRecords[0].avatar,
        'name2': widget.playerReadRecords[1].name,
        'avatar2': widget.playerReadRecords[1].avatar,
      };
    } else if (widget.winner == 2) {
      result = {
        'name1': widget.playerReadRecords[2].name,
        'avatar1': widget.playerReadRecords[2].avatar,
        'name2': widget.playerReadRecords[3].name,
        'avatar2': widget.playerReadRecords[3].avatar,
      };
    }

    return result;
  }

  Widget _buildTopCard() {
    return Card(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CustomCircleAvatar(
                                widget.playerReadRecords[0].avatar,
                                radius: 25.0,
                                iconSize: 20.0,
                              ),
                              CustomCircleAvatar(
                                widget.playerReadRecords[1].avatar,
                                radius: 25.0,
                                iconSize: 20.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(widget.playerReadRecords[0].name),
                          Text(widget.playerReadRecords[1].name),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(widget.gameTime),
                          ScoreLabel(
                            widget.team1Points.toString() +
                                ' : ' +
                                widget.team2Points.toString(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CustomCircleAvatar(
                                widget.playerReadRecords[2].avatar,
                                radius: 25.0,
                                iconSize: 20.0,
                              ),
                              CustomCircleAvatar(
                                widget.playerReadRecords[3].avatar,
                                radius: 25.0,
                                iconSize: 20.0,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(widget.playerReadRecords[2].name),
                          Text(widget.playerReadRecords[3].name),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).accentColor,
            thickness: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
//                  color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    Text('${S.of(context).handsPlayed}: ${widget.length}'),
                    Text('${S.of(context).maxReadIs}: ${getMaxRead()}'),
                    Text('${S.of(context).gameFinishedIn}: ${widget.gameTime}'),
                    Text(
                        '${S.of(context).doublePositive}: ${widget.dPosCount}'),
                    Text(
                        '${S.of(context).doubleNegative}: ${widget.dNegCount}'),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                padding: EdgeInsets.all(10.0),
//                  color: Theme.of(context).primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.event_note,
                          size: 36.0,
                        ),
                        Text(
                          S.of(context).scores,
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(widget.team1Points.toString(),
                        style: Theme.of(context).textTheme.subtitle),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(widget.team2Points.toString(),
                        style: Theme.of(context).textTheme.subtitle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCards(PlayerReadRecords player) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            CustomCircleAvatar(
              player.avatar,
              radius: 30.0,
              iconSize: 35.0,
              circleColor: Theme.of(context).accentColor,
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: SingleChildScrollView(
              child:
                  Text(player.name, style: Theme.of(context).textTheme.body2),
            )),
            SizedBox(
              width: 8.0,
            ),
            Column(
              children: <Widget>[
                ScoreLabel(getPlayerScore(player).toString()),
                Text('${S.of(context).wins} : ${player.wins}',
                    style: Theme.of(context).textTheme.body1),
                Text('${S.of(context).looses} : ${player.looses}',
                    style: Theme.of(context).textTheme.body1),
                Text(
                    '${S.of(context).topRead} : ${getStringRead(player.topRead)}',
                    style: Theme.of(context).textTheme.body1),
//                Text('${S.of(context).readCount} : ${player.readCount}',
//                    style: Theme.of(context).textTheme.body1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(S.of(context).gameDetails),
        elevation: 0,
      ),
      drawer: SideDrawer(),
      body: Column(
        children: <Widget>[
          _buildTopCard(),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildPlayerCards(widget.playerReadRecords[0]),
                _buildPlayerCards(widget.playerReadRecords[1]),
                _buildPlayerCards(widget.playerReadRecords[2]),
                _buildPlayerCards(widget.playerReadRecords[3]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
