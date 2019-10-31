import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/models/constants.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/models/points_table.dart';

import '../models/constants.dart';

class ChartListViewLastGames extends StatefulWidget {
  final List<PlayerTable> players;
  final List<PointsTable> points;

  ChartListViewLastGames(this.players, this.points);

  @override
  State<StatefulWidget> createState() {
    return _ChartListViewLastGamesState();
  }
}

class _ChartListViewLastGamesState extends State<ChartListViewLastGames> {
  bool isDeleted = false;

  Map<String, Color> _chooseColor(int index) {
    String gameCase = widget.points[index].whichColor;
    int starter = widget.points[index].starter;

    Color winColor = Colors.green.shade400;
    Color lossColor = Colors.red.shade400;
    Color defaultColor = Colors.orange.shade300;
    Color noColor = Colors.white;

    Color color1;
    Color color2;

    if (starter == 1 || starter == 2) {
      switch (gameCase) {
        case Constants.READ_CASE:
          color1 = defaultColor;
          color2 = noColor;
          break;
        case Constants.WIN_CASE:
          color1 = winColor;
          color2 = noColor;
          break;
        case Constants.LOSE_CASE:
          color1 = lossColor;
          color2 = noColor;
          break;
      }
    }
    if (starter == 3 || starter == 4) {
      switch (gameCase) {
        case Constants.READ_CASE:
          color1 = noColor;
          color2 = defaultColor;
          break;
        case Constants.WIN_CASE:
          color1 = noColor;
          color2 = winColor;
          break;
        case Constants.LOSE_CASE:
          color1 = noColor;
          color2 = lossColor;
          break;
      }
    }
    if (starter == 0) {
      color1 = noColor;
      color2 = noColor;
    }

    Map<String, Color> colors = {'1': color1, '2': color2};

    return colors;
  }

  String _getStarterName(int index, int starter) {
    String name;
    switch (starter) {
      case 1:
        name = widget.players[0].name;
        break;
      case 2:
        name = widget.players[1].name;
        break;
      case 3:
        name = widget.players[2].name;
        break;
      case 4:
        name = widget.players[3].name;
        break;
    }
    return name;
  }

  Widget _buildBody(int index) {
    Map<String, Color> colors = _chooseColor(index);

    EdgeInsets itemPadding = EdgeInsets.all(8.0);
    EdgeInsets gradientPadding = EdgeInsets.all(4.0);
    SizedBox verticalGap = SizedBox(
      width: 4.0,
    );

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 32.0,
            padding: itemPadding,
            color: Colors.grey,
            child: Text((index + 1).toString()),
          ),
          verticalGap,
          CustomCircleAvatar(
            widget.players[widget.points[index].starter - 1].avatar,
            radius: 15.0,
            iconSize: 15.0,
          ),
          verticalGap,
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Visibility(
                  visible: widget.points[index].starter == 1 ||
                          widget.points[index].starter == 2
                      ? true
                      : false,
                  child: Positioned(
                    right: 50.0,
                    left: 0.0,
                    child: Container(
                      padding: gradientPadding,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [colors['1'], Colors.white],
                        ),
                      ),
                      child: Text(''),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.points[index].starter == 3 ||
                          widget.points[index].starter == 4
                      ? true
                      : false,
                  child: Positioned(
                    left: 50.0,
                    right: 0.0,
                    child: Container(
                        padding: gradientPadding,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [colors['2'], Colors.white],
                          ),
                        ),
                        child: Text('')),
                  ),
                ),
                Container(
                    padding: gradientPadding,
                    child: SingleChildScrollView(
                        child: Text(
                      _getStarterName(index, widget.points[index].starter),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ))),
              ],
            ),
          ),
          verticalGap,
          Container(
            padding: itemPadding,
            width: 50.0,
            child: Text(
              widget.points[index].team1Points,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: itemPadding,
            width: 50.0,
            child: Text(
              widget.points[index].readPoints,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: itemPadding,
            width: 50.0,
            child: Text(
              widget.points[index].team2Points,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
      child: ListView.builder(
        itemCount: widget.points.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildBody(index);
        },
      ),
    );
  }
}
