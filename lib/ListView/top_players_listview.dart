import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/score_label.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/models/top_players_item.dart';
import 'package:shelem_shomar/pages/top_players.dart';

class TopPlayersListView extends StatefulWidget {
  final CollectAllData data;
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

  Animation _animation0, _animation1, _animation2;
  AnimationController _animationController;

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

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation0 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.3, curve: Curves.bounceIn)));
    _animation1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.6, curve: Curves.bounceIn)));
    _animation2 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.9, curve: Curves.bounceIn)));

    _animationController.forward();
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

  _buildBody() {
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? Column(
              children: <Widget>[
                Container(
                  child: _buildTopCard(),
                ),
                Expanded(child: _buildBody()),
              ],
            )
                : Row(
              children: <Widget>[
                Container(
                  child: _buildTopCard(),
                ),
                Expanded(child: _buildBody()),
              ],
            );
          },
        );
      },
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

  _buildTopCard() {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Transform(
            transform:
            Matrix4.translationValues(0.0, _animation2.value * width, 0.0),
            child: _buildTopChildCards(index: 2),
          ),
          Transform(
            transform:
            Matrix4.translationValues(0.0, _animation0.value * width, 0.0),
            child: _buildTopChildCards(index: 0),
          ),
          Transform(
            transform:
            Matrix4.translationValues(0.0, _animation1.value * width, 0.0),
            child: _buildTopChildCards(index: 1),
          ),
        ],
      ),
    );
  }

  _buildTopChildCards({@required int index}) {
    String _imageName;
    double _padding;
    Color _color;

    switch (index) {
      case 0:
        _imageName = 'assets/images/one.png';
        _padding = 12.0;
        _color = Colors.amber.withOpacity(0.3);
        break;
      case 1:
        _imageName = 'assets/images/two.png';
        _padding = 8.0;
        _color = Colors.grey.withOpacity(0.3);
        break;
      case 2:
        _imageName = 'assets/images/three.png';
        _padding = 8.0;
        _color = Colors.deepOrange.withOpacity(0.3);
        break;
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _color,
        ),
        padding: EdgeInsets.all(_padding),
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomCircleAvatar(
                  _getPlayerAvatar(mItems[index].getPlayerId()),
                  radius: 20.0,
                  iconSize: 20.0,
                ),
                SizedBox(
                  width: 2.0,
                ),
                Image.asset(
                  _imageName,
                  width: 30.0,
                  height: 30.0,
                ),
              ],
            ),
            Container(
              width: 80.0,
              child: Center(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _getPlayerName(mItems[index].getPlayerId()),
                    )),
              ),
            ),
            ScoreLabel(
              mItems[index].getScore().toString(),
              fontSize: 18.0,
              height: 30.0,
              width: 50.0,
            ),
            Text(
              '${mItems[index].getWins()} ${S
                  .of(context)
                  .wins}\n${mItems[index].getLosses()} ${S
                  .of(context)
                  .looses}',
            ),
          ],
        ),
      ),
    );
  }
}
