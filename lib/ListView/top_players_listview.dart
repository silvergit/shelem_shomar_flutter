import 'package:flutter/material.dart';
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

class _TopPlayersListViewState extends State<TopPlayersListView> {
  List<TopPlayersItem> mItems = [];
  final List<Color> colors = [
    Colors.green.shade300,
    Colors.green.shade200,
    Colors.green.shade100,
    Colors.green.shade50,
//    Colors.blue.shade50,
//    Colors.blue.shade100,
//    Colors.blue.shade200,
//    Colors.blue.shade300,
//    Colors.blue.shade200,
//    Colors.blue.shade100,
//    Colors.blue.shade50,
//    Colors.amber.shade50,
//    Colors.amber.shade100,
//    Colors.amber.shade200,
//    Colors.amber.shade300,
//    Colors.amber.shade200,
//    Colors.amber.shade100,
//    Colors.amber.shade50,
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
    return ListView.builder(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: CustomCircleAvatar(
                widget.data.players[index].avatar,
                radius: 25.0,
                iconSize: 30.0,
                circleColor: Theme
                    .of(context)
                    .accentColor,
              ),
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.data.players[index].name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              subtitle: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ScoreLabel(
                      '${mItems[index].getWins()} ${S
                          .of(context)
                          .wins}',
                      fontSize: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .fontSize,
                      height: 24.0,
                      transparent: 0.5,
                      fontColor: Colors.amber,
                      margin: 0.0,
                    ),
                    ScoreLabel(
                      '${mItems[index].getLosses()} ${S
                          .of(context)
                          .looses}',
                      fontSize: Theme
                          .of(context)
                          .textTheme
                          .body1
                          .fontSize,
                      height: 24.0,
                      transparent: 0.5,
                      fontColor: Colors.amber,
                      margin: 2.0,
                    ),
                  ],
                ),
              ),
              trailing: ScoreLabel(
                mItems[index].getScore().toString(),
                margin: 0.0,
                backColor: _getColor(index),
              ),
            ),
            Divider()
          ],
        );
      },
      itemCount: mItems.length,
    );
  }

  Widget _buildGridType() {
    return GridView.builder(
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
//      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: <Widget>[
              ScoreLabel(
                mItems[index].getScore().toString(),
                margin: 0.0,
                backColor: _getColor(index),
                height: 48.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.data.players[index].name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomCircleAvatar(widget.data.players[index].avatar,
                    radius: 25.0,
                    iconSize: 30.0,
                    circleColor: Theme
                        .of(context)
                        .accentColor,),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ScoreLabel(
                      '${mItems[index].getWins()} ${S
                          .of(context)
                          .wins}\n${mItems[index].getLosses()} ${S
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
      itemCount: mItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
