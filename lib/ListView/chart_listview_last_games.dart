import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
import 'package:shelem_shomar/models/constants.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/models/points_table.dart';

import '../models/constants.dart';

class ChartListViewLastGames extends StatefulWidget {
  final List<PlayerTable> players;
  final List<PointsTable> points;
  final int listTypeIndex;

  ChartListViewLastGames(this.players, this.points, this.listTypeIndex);

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
      default:
        name = 'Last points';
    }
    return name;
  }

  _buildBody(int index) {
    Locale myLocale = Localizations.localeOf(context);
    switch (widget.listTypeIndex) {
      case 0:
        return _linearColorType(index, myLocale.languageCode);
        break;
      case 1:
        return _gradientColorType(index, myLocale.languageCode);
        break;
      case 2:
        return _simpleType(index, myLocale.languageCode);
        break;
    }
  }

  Widget _gradientColorType(int index, String languageCode) {
    Map<String, Color> colors = _chooseGradientColor(index);

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 32.0,
            padding: EdgeInsets.all(8.0),
            color: Colors.grey,
            child: TextWithLocale((index + 1).toString(), languageCode),
          ),
          SizedBox(
            width: 4.0,
          ),
          CustomCircleAvatar(
            widget.players[widget.points[index].starter - 1].avatar,
            radius: 15.0,
            iconSize: 15.0,
          ),
          SizedBox(
            width: 4.0,
          ),
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
                      padding: EdgeInsets.all(8.0),
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
                        padding: EdgeInsets.all(8.0),
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
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                        child: Text(
                          _getStarterName(index, widget.points[index].starter),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ))),
              ],
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            width: 50.0,
            child: TextWithLocale(
              widget.points[index].team1Points,
              languageCode,
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(8.0),
            width: 50.0,
            child: TextWithLocale(
              widget.points[index].readPoints,
              languageCode,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            width: 50.0,
            child: TextWithLocale(
              widget.points[index].team2Points,
              languageCode,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _chooseGradientColor(int index) {
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

  Widget _simpleType(int index, String languageCode) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      leading: Container(
        width: 32.0,
        padding: EdgeInsets.all(10.0),
        color: Theme
            .of(context)
            .cardColor,
        child: TextWithLocale((index + 1).toString(), languageCode),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(width: 50.0,
              child: TextWithLocale(
                  widget.points[index].team1Points, languageCode)),
          Container(width: 50.0,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextWithLocale(widget.points[index].readPoints, languageCode),
                Text(widget.points[index].starter == 1 ||
                    widget.points[index].starter == 2
                    ? '<--'
                    : '-->'),
              ],
            ),
          ),
          Container(width: 50.0,
              child: TextWithLocale(
                  widget.points[index].team2Points, languageCode)),
        ],
      ),
    );
  }

  Widget _linearColorType(int index, String languageCode) {
    return Container(
      color: Theme
          .of(context)
          .cardColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        leading: Container(
          width: 32.0,
          padding: EdgeInsets.all(8.0),
          color: Theme
              .of(context)
              .cardColor,
          child: TextWithLocale((index + 1).toString(), languageCode),
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _getStarterName(index, widget.points[index].starter),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                width: 50.0,
                child: Column(
                  children: <Widget>[
                    TextWithLocale(
                        widget.points[index].team1Points, languageCode),
                    _buildBoxColor(index, '1'),
                  ],
                ),
              ),
              _buildVerticalDivider(),
              Container(
                color: Theme
                    .of(context)
                    .cardColor,
                padding: EdgeInsets.all(8.0),
                width: 50.0,
                child: TextWithLocale(
                    widget.points[index].readPoints, languageCode),
              ),
              _buildVerticalDivider(),
              Container(
                padding: EdgeInsets.all(8.0),
                width: 50.0,
                child: Column(
                  children: <Widget>[
                    TextWithLocale(
                        widget.points[index].team2Points, languageCode),
                    _buildBoxColor(index, '2'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 20.0,
      width: 1.0,
      color: Colors.white30,
    );
  }

  Widget _buildBoxColor(int index, String colorIndex) {
    return Container(
      width: 50.0,
      height: 10.0,
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: _chooseColor(index)[colorIndex],
      ),
      child: Text(''),
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
