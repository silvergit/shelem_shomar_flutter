import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/score_label.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/models/top_players_item.dart';
import 'package:shelem_shomar/pages/top_players.dart';

class TopPlayersListView extends StatefulWidget {
  final CollectAllDatas data;
  final int listGridTypeIndex;

  TopPlayersListView(this.data, this.listGridTypeIndex);

  @override
  State<StatefulWidget> createState() {
    return _TopPlayersListViewState();
  }
}

class _TopPlayersListViewState extends State<TopPlayersListView>
    with SingleTickerProviderStateMixin {
  List<TopPlayersItem> mItems = [];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.green.shade200,
    Colors.green.shade100,
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.blue.shade100,
    Colors.blue.shade200,
    Colors.blue.shade300,
    Colors.blue.shade200,
    Colors.blue.shade100,
    Colors.blue.shade50,
    Colors.amber.shade50,
    Colors.amber.shade100,
    Colors.amber.shade200,
    Colors.amber.shade300,
    Colors.amber.shade200,
    Colors.amber.shade100,
    Colors.amber.shade50,
    Colors.red.shade50,
    Colors.red.shade100,
    Colors.red.shade200,
    Colors.red.shade300,
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.data.players.length; i++) {
      int pId = widget.data.players[i].id;

      int playerWins = 0;
      int playerLosses = 0;

      for (int j = 0; j < widget.data.states.length; j++) {
        if (widget.data.states[j].playerId == pId) {
          if (widget.data.states[j].state == 1) {
            playerWins++;
          } else if (widget.data.states[j].state == 0) {
            playerLosses++;
          }
        }
      }
      TopPlayersItem item = TopPlayersItem();
      item.setPlayerId(pId);
      item.setWins(playerWins);
      item.setLosses(playerLosses);
      mItems.add(item);
    }

    mItems.sort((a, b) => b.getScore().compareTo(a.getScore()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color _getColor(int index) {
    double m = colors.length / mItems.length;
    double p = m * index;
    return colors[p.round()];
  }

  Widget _buildBody() {
    switch (widget.listGridTypeIndex) {
      case 0:
        return _buildListType();
        break;
      case 1:
        return _buildGridType();
        break;
    }
  }

  Widget _buildListType() {
    var subItems = mItems.sublist(3);

    return ListView.builder(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .accentColor,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Text((index + 4).toString())),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: Theme
                              .of(context)
                              .primaryColor, width: 2.0)),
                  child: Row(
                    children: <Widget>[
                      CustomCircleAvatar(
                        _getPlayerAvatar(subItems[index].getPlayerId()),
                        radius: 25.0,
                        iconSize: 30.0,
                        circleColor: Theme
                            .of(context)
                            .accentColor,
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                _getPlayerName(subItems[index].getPlayerId()),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      '${subItems[index].getWins()} ${S
                                          .of(context)
                                          .wins}'),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    '${subItems[index].getLosses()} ${S
                                        .of(context)
                                        .looses}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ScoreLabel(
                        subItems[index].getScore().toString(),
                        margin: 0.0,
                        backColor: _getColor(index),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: subItems.length,
    );
  }

  Widget _buildGridType() {
    var subItems = mItems.sublist(3);

    return GridView.builder(
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: <Widget>[
              ScoreLabel(
                subItems[index].getScore().toString(),
                margin: 0.0,
                backColor: _getColor(index),
                height: 48.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _getPlayerName(subItems[index].getPlayerId()),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomCircleAvatar(
                    _getPlayerAvatar(subItems[index].getPlayerId()),
                    radius: 25.0,
                    iconSize: 30.0,
                    circleColor: Theme
                        .of(context)
                        .accentColor,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ScoreLabel(
                      '${subItems[index].getWins()} ${S
                          .of(context)
                          .wins}\n${subItems[index].getLosses()} ${S
                          .of(context)
                          .looses}',
                      fontSize: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .fontSize,
                      height: 48.0,
                      transparent: 0.5,
                      fontColor: Colors.amber,
                      margin: 0.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: subItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double tileSize = width / 4;

    return Column(
      children: <Widget>[
        Container(
          color: Theme
              .of(context)
              .accentColor,
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomCircleAvatar(
                _getPlayerAvatar(mItems[2].getPlayerId()),
                radius: 20.0,
                iconSize: 20.0,
              ),
              CustomCircleAvatar(
                _getPlayerAvatar(mItems[0].getPlayerId()),
                radius: 20.0,
                iconSize: 20.0,
              ),
              CustomCircleAvatar(
                _getPlayerAvatar(mItems[1].getPlayerId()),
                radius: 20.0,
                iconSize: 20.0,
              ),
            ],
          ),
        ),
        Container(
          color: Theme
              .of(context)
              .accentColor,
          width: width,
          height: height / 3,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: tileSize,
                    height: tileSize * 1.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.green.shade200,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(_getPlayerName(mItems[0]
                                .getPlayerId()))),
                        ScoreLabel(
                          mItems[0].getScore().toString(),
                          fontSize: 18.0,
                          height: 30.0,
                          width: 50.0,
                        ),
                        Text(
                          '${mItems[0].getWins()} ${S
                              .of(context)
                              .wins}\n${mItems[0].getLosses()} ${S
                              .of(context)
                              .looses}',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.0,),
                ],
              ),
              Positioned(
                top: 5,
                child: Image.asset(
                  'assets/images/one.png',
                  width: tileSize / 3,
                  height: tileSize / 3,
                ),
              ),
              Positioned(
                bottom: tileSize / 4,
                left: tileSize / 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.yellow.shade300,
                  ),
                  width: tileSize,
                  height: tileSize * 1.4,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(_getPlayerName(mItems[1].getPlayerId()))),
                      ScoreLabel(
                        mItems[1].getScore().toString(),
                        fontSize: 18.0,
                        height: 30.0,
                        width: 50.0,
                      ),
                      Text(
                        '${mItems[1].getWins()} ${S
                            .of(context)
                            .wins}\n${mItems[1].getLosses()} ${S
                            .of(context)
                            .looses}',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: tileSize,
                child: Image.asset(
                  'assets/images/two.png',
                  width: tileSize / 3,
                  height: tileSize / 3,
                ),
              ),
              Positioned(
                bottom: tileSize / 4,
                right: tileSize / 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.deepOrange.shade200,
                  ),
                  width: tileSize,
                  height: tileSize * 1.4,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(_getPlayerName(mItems[2].getPlayerId()))),
                      ScoreLabel(
                        mItems[2].getScore().toString(),
                        fontSize: 18.0,
                        height: 30.0,
                        width: 50.0,
                      ),
                      Text(
                        '${mItems[2].getWins()} ${S
                            .of(context)
                            .wins}\n${mItems[2].getLosses()} ${S
                            .of(context)
                            .looses}',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: tileSize,
                child: Image.asset(
                  'assets/images/three.png',
                  width: tileSize / 3,
                  height: tileSize / 3,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  String _getPlayerName(int playerId) {
    for (var player in widget.data.players)
      if (player.id == playerId) return player.name;
    return '';
  }

  String _getPlayerAvatar(int playerId) {
    for (var player in widget.data.players)
      if (player.id == playerId) return player.avatar;
    return '';
  }
}
