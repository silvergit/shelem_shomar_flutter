import 'package:flutter/material.dart';
import 'package:flutter_slidable_list_view/flutter_slidable_list_view.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/models/constants.dart';
import 'package:shelem_shomar/models/in_game_list_item.dart';
import 'package:shelem_shomar/models/player_table.dart';

import '../models/constants.dart';

class ChartListView extends StatefulWidget {
  final List<Item> points;

  final Function setState;
  final Function updateResults;
  final bool buttonOpenCloseText;
  final Function changeButtonStartEndState;
  final PlayerTable t1p1;
  final PlayerTable t1p2;
  final PlayerTable t2p1;
  final PlayerTable t2p2;
  final int listTypeIndex;

  ChartListView(
    this.points,
    this.t1p1,
    this.t1p2,
    this.t2p1,
    this.t2p2,
    this.setState,
    this.updateResults,
    this.buttonOpenCloseText,
    this.changeButtonStartEndState,
      this.listTypeIndex,
  );

  @override
  State<StatefulWidget> createState() {
    return _ChartListView();
  }
}

class _ChartListView extends State<ChartListView> {
  bool isDeleted = false;
  EdgeInsets itemPadding = EdgeInsets.all(8.0);
  EdgeInsets colorBoxPadding = EdgeInsets.all(4.0);
  Locale myLocale;
  SizedBox verticalGap = SizedBox(
    width: 4.0,
  );

  Map<String, Color> _chooseColor(int index) {
    String gameCase = widget.points[index].whichColor;
    int starter = widget.points[index].starter;

    Color winColor = Colors.green.shade600;
    Color lossColor = Colors.red.shade400;
    Color defaultColor = Colors.orange.shade300;
    Color noColor = Colors.transparent;

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
        name = widget.t1p1.name;
        break;
      case 2:
        name = widget.t1p2.name;
        break;
      case 3:
        name = widget.t2p1.name;
        break;
      case 4:
        name = widget.t2p2.name;
        break;
      default:
        name = 'Last points';
    }
    return name;
  }

  void deleteItem(int index) {
    setState(() {
      print(widget.points.length - 1);
      print(index);
      if (!widget.buttonOpenCloseText && index == (widget.points.length - 1)) {
        widget.changeButtonStartEndState();
      }
      widget.points.removeAt(index);
    });
    widget.setState(true);
    widget.updateResults();
  }

  _buildBody(int index) {
    myLocale = Localizations.localeOf(context);
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    Widget _child;
    switch (widget.listTypeIndex) {
      case 0:
        _child = _linearColorType(index, myLocale.languageCode);
        break;
      case 1:
        _child = _gradientColorType(index, myLocale.languageCode);
        break;
      case 2:
        _child = _simpleType(index, myLocale.languageCode);
        break;
    }

    return Container(
      margin: portraitOrientation ? null : EdgeInsets.only(top: 8.0),
      color: Colors.blue,
      width: portraitOrientation ? width : width / 3 * 2,
      child: _child,
    );
  }

  Widget _gradientColorType(int index, String languageCode) {
    Map<String, Color> colors = _chooseGradientColor(index);
    List<PlayerTable> players = [
      widget.t1p1,
      widget.t1p2,
      widget.t2p1,
      widget.t2p2
    ];

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 32.0,
            padding: itemPadding,
            color: Colors.grey,
            child: TextWithLocale((index + 1).toString(), languageCode),
          ),
          verticalGap,
          CustomCircleAvatar(
            index > 0 ? players[widget.points[index].starter - 1].avatar : null,
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
                      child: Text(''),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      _getStarterName(index, widget.points[index].starter),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalGap,
          Container(
            padding: itemPadding,
            width: 50.0,
            child: TextWithLocale(
              widget.points[index].team1HandPoints,
              languageCode,
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: itemPadding,
            width: 50.0,
            child: TextWithLocale(
              widget.points[index].readPoints,
              languageCode,
            ),
          ),
          Container(
            padding: itemPadding,
            width: 50.0,
            child: TextWithLocale(
              widget.points[index].team2HandPoints,
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
    List<PlayerTable> players = [
      widget.t1p1,
      widget.t1p2,
      widget.t2p1,
      widget.t2p2
    ];

    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: Container(
        width: 32.0,
        padding: EdgeInsets.all(10.0),
        color: Theme
            .of(context)
            .cardColor,
        child: TextWithLocale((index + 1).toString(), languageCode),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomCircleAvatar(
            widget.points[index].starter > 0
                ? players[widget.points[index].starter - 1].avatar
                : null,
            radius: 15.0,
            iconSize: 15.0,
          ),
          SizedBox(
            width: 20.0,
          ),
          Container(
              width: 60.0,
              child: TextWithLocale(
                  widget.points[index].team1HandPoints, languageCode)),
          Container(
            width: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Visibility(
                    visible: widget.points[index].starter == 1 ||
                        widget.points[index].starter == 2
                        ? true
                        : false,
                    child: Icon(Icons.arrow_left)),
                TextWithLocale(widget.points[index].readPoints, languageCode),
                Visibility(
                    visible: widget.points[index].starter == 3 ||
                        widget.points[index].starter == 4
                        ? true
                        : false,
                    child: Icon(Icons.arrow_right)),
              ],
            ),
          ),
          Container(
              width: 60.0,
              child: TextWithLocale(
                  widget.points[index].team2HandPoints, languageCode)),
        ],
      ),
    );
  }

  Widget _linearColorType(int index, String languageCode) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
        leading: Container(
          width: 32.0,
          padding: itemPadding,
          color: Theme.of(context).cardColor,
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
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
              ),
              Container(
                padding: itemPadding,
                width: 55.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWithLocale(
                        widget.points[index].team1HandPoints, languageCode),
                    _buildBoxColor(index, '1'),
                  ],
                ),
              ),
              _buildVerticalDivider(),
              Container(
                color: Theme.of(context).cardColor,
                padding: itemPadding,
                width: 50.0,
                child: TextWithLocale(
                    widget.points[index].readPoints, languageCode),
              ),
              _buildVerticalDivider(),
              Container(
                padding: itemPadding,
                width: 55.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextWithLocale(
                        widget.points[index].team2HandPoints, languageCode),
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
      padding: colorBoxPadding,
      decoration: BoxDecoration(
        color: _chooseColor(index)[colorIndex],
      ),
      child: Text(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return Center(
        child: Text(
          S.of(context).openHandToStart,
          style: Theme.of(context).textTheme.subtitle,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
      child: SlideListView(
        itemBuilder: (bc, index) {
          return _buildBody(index);
        },
        actionWidgetDelegate: ActionWidgetDelegate(1, (index) {
          if (index == 0) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.delete,
                  color: Colors.white,
                )
              ],
            );
          } else {
            return null;
          }
        }, (int indexInList, int index, BaseSlideItem item) {
          if (index == 0) {
            deleteItem(indexInList);
            item.close();
          } else {
            item.close();
          }
        }, [Colors.red.shade300]),
        dataList: widget.points,
        refreshCallback: () async {
          await Future.delayed(Duration(seconds: 2));

          return;
        },
        refreshWidgetBuilder: (Widget content, RefreshCallback callback) {
          return RefreshIndicator(
            child: content,
            onRefresh: callback,
          );
        },
      ),
    );
  }
}
