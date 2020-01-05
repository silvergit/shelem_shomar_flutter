import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/score_label.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
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
  @override
  initState() {
    return super.initState();
  }

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

  Widget _buildTopCard(String languageCode) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Container(
            width: portraitOrientation ? null : width / 2,
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
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(widget.playerReadRecords[0].name)),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(widget.playerReadRecords[1].name)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          TextWithLocale(widget.gameTime, languageCode),
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
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.playerReadRecords[2].name,
                              )),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(widget.playerReadRecords[3].name)),
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
          portraitOrientation
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextWithLocale(
                      '${S
                          .of(context)
                          .handsPlayed}: ${widget.length}',
                      languageCode,
                      fontSize: 14.0,
                    ),
                    TextWithLocale(
                      '${S
                          .of(context)
                          .maxReadIs}: ${getMaxRead()}',
                      languageCode,
                      fontSize: 14.0,
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    TextWithLocale(
                      '${S
                          .of(context)
                          .gameFinishedIn}: ${widget.gameTime}',
                      languageCode,
                      fontSize: 14.0,
                    ),
                    TextWithLocale(
                      '${S
                          .of(context)
                          .doublePositive}: ${widget.dPosCount}',
                      languageCode,
                      fontSize: 14.0,
                    ),
                    TextWithLocale(
                      '${S
                          .of(context)
                          .doubleNegative}: ${widget.dNegCount}',
                      languageCode,
                      fontSize: 14.0,
                    ),
                  ],
                ),
              ),
            ],
          )
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextWithLocale(
                          '${S
                              .of(context)
                              .handsPlayed}: ${widget.length}',
                          languageCode,
                          fontSize: 14.0,
                        ),
                        TextWithLocale(
                          '${S
                              .of(context)
                              .maxReadIs}: ${getMaxRead()}',
                          languageCode,
                          fontSize: 14.0,
                        ),
                        TextWithLocale(
                          '${S
                              .of(context)
                              .gameFinishedIn}: ${widget.gameTime}',
                          languageCode,
                          fontSize: 14.0,
                        ),
                        TextWithLocale(
                          '${S
                              .of(context)
                              .doublePositive}: ${widget.dPosCount}',
                          languageCode,
                          fontSize: 14.0,
                        ),
                        TextWithLocale(
                          '${S
                              .of(context)
                              .doubleNegative}: ${widget.dNegCount}',
                          languageCode,
                          fontSize: 14.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCards(PlayerReadRecords player, String languageCode) {
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
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Text(player.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2),
                  ),
                  SingleChildScrollView(
                    child: TextWithLocale(
                        '${S
                            .of(context)
                            .topRead} : ${getStringRead(player.topRead)}',
                        languageCode,
                        fontSize: 12.0),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ScoreLabel(getPlayerScore(player).toString()),
                TextWithLocale(
                    '${S
                        .of(context)
                        .wins} : ${player.wins}', languageCode,
                    fontSize: 12.0),
                TextWithLocale(
                    '${S
                        .of(context)
                        .looses} : ${player.looses}', languageCode,
                    fontSize: 12.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations
        .localeOf(context)
        .languageCode;

    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).gameDetails),
        elevation: 0,
      ),
      drawer: SideDrawer(),
      body: portraitOrientation
          ? Column(
        children: <Widget>[
          _buildTopCard(languageCode),
          Expanded(
            child: ListView.builder(
              itemCount: widget.playerReadRecords.length,
              itemBuilder: (context, index) {
                return _buildPlayerCards(
                    widget.playerReadRecords[index], languageCode);
              },
            ),
          )
        ],
      )
          : Row(
        children: <Widget>[
          _buildTopCard(languageCode),
          Expanded(
            child: ListView.builder(
              itemCount: widget.playerReadRecords.length,
              itemBuilder: (context, index) {
                return _buildPlayerCards(
                    widget.playerReadRecords[index], languageCode);
              },
            ),
          ),
        ],
      ),
    );
  }
}
