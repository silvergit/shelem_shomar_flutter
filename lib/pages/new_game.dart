import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelem_shomar/Widgets/bottom-bar-newgame.dart';
import 'package:shelem_shomar/Widgets/my-buttons.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/pages/in_game.dart';
import 'package:shelem_shomar/pages/select_player.dart';

class NewGamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewGamePage();
  }
}

class _NewGamePage extends State<NewGamePage> {
  String _gameType = '';
  bool _getAfter = false;

  PlayerTable t1p1 = PlayerTable();
  PlayerTable t1p2 = PlayerTable();
  PlayerTable t2p1 = PlayerTable();
  PlayerTable t2p2 = PlayerTable();

  String t1InitPoints;
  String t2InitPoints;

  int _gameTypeChipValue = 1;
  int _getPointsChipValue = 2;
  int _doublePosValue = 0;
  int _doubleNegValue = 0;

  SharedPreferences prefs;

  TextEditingController _t1InitPointController;
  TextEditingController _t2InitPointController;

  void _saveSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    List<String> _t1p1 = [t1p1.id.toString(), t1p1.name, t1p1.avatar];
    List<String> _t1p2 = [t1p2.id.toString(), t1p2.name, t1p2.avatar];
    List<String> _t2p1 = [t2p1.id.toString(), t2p1.name, t2p1.avatar];
    List<String> _t2p2 = [t2p2.id.toString(), t2p2.name, t2p2.avatar];
    await prefs.setStringList('t1p1', _t1p1);
    await prefs.setStringList('t1p2', _t1p2);
    await prefs.setStringList('t2p1', _t2p1);
    await prefs.setStringList('t2p2', _t2p2);
    await prefs.setInt("gameType", _gameTypeChipValue);
    await prefs.setBool("dPoz", _doublePosValue == 0 ? false : true);
    await prefs.setBool("dNeg", _doubleNegValue == 0 ? false : true);
    await prefs.setInt('getPointsAfter', _getPointsChipValue);
  }

  void _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    PlayerTable _t1p1 = PlayerTable();
    PlayerTable _t1p2 = PlayerTable();
    PlayerTable _t2p1 = PlayerTable();
    PlayerTable _t2p2 = PlayerTable();

    List<String> t1p1list = prefs.getStringList('t1p1');
    List<String> t1p2list = prefs.getStringList('t1p2');
    List<String> t2p1list = prefs.getStringList('t2p1');
    List<String> t2p2list = prefs.getStringList('t2p2');

    if (t1p1list != null) {
      _t1p1.id = int.tryParse(t1p1list[0] == null ? '' : t1p1list[0]);
      _t1p1.name = t1p1list[1];
      _t1p1.avatar = t1p1list[2];
    }

    if (t1p2list != null) {
      _t1p2.id = int.tryParse(t1p2list[0] == null ? '' : t1p2list[0]);
      _t1p2.name = t1p2list[1];
      _t1p2.avatar = t1p2list[2];
    }

    if (t2p1list != null) {
      _t2p1.id = int.tryParse(t2p1list[0] == null ? '' : t2p1list[0]);
      _t2p1.name = t2p1list[1];
      _t2p1.avatar = t2p1list[2];
    }

    if (t2p2list != null) {
      _t2p2.id = int.tryParse(t2p2list[0] == null ? '' : t2p2list[0]);
      _t2p2.name = t2p2list[1];
      _t2p2.avatar = t2p2list[2];
    }

    int gType = prefs.getInt('gameType') == null ? 1 : prefs.getInt('gameType');

    _setGameType(gType);

    int getType = prefs.getInt('getPointsAfter') == null
        ? 1
        : prefs.getInt('getPointsAfter');

    _setGetPointsAfter(getType);

    bool dPoz = prefs.getBool('dPoz') == null ? false : prefs.getBool('dPoz');
    bool dNeg = prefs.getBool('dNeg') == null ? false : prefs.getBool('dNeg');

    setState(() {
      if (_t1p1 != null) {
        t1p1 = _t1p1;
      }
      if (_t1p2 != null) {
        t1p2 = _t1p2;
      }
      if (_t2p1 != null) {
        t2p1 = _t2p1;
      }
      if (_t2p2 != null) {
        t2p2 = _t2p2;
      }

      _gameTypeChipValue = gType;
      _getPointsChipValue = getType;
      _doublePosValue = dPoz ? 1 : 0;
      _doubleNegValue = dNeg ? 1 : 0;
    });
  }

  void _setGameType(int value) => setState(() {
        switch (value) {
          case 1:
            _gameType = '165';
            break;
          case 2:
            _gameType = '185';
            break;
          case 3:
            _gameType = '200';
            break;
          case 4:
            _gameType = '225';
            break;
          case 5:
            _gameType = '230';
            break;
        }
      });

  void _setGetPointsAfter(int value) =>
      setState(() {
        switch (value) {
          case 1:
            _getAfter = true;
            break;
          case 2:
            _getAfter = false;
            break;
        }
      });

  Widget _buildHeaderTexts(String text) {
    return new TextWithLocale(
      text,
      Localizations
          .localeOf(context)
          .languageCode,
      fontSize: 18.0,
      fontColor: Colors.white,
      textAlignEn: TextAlign.start,
      textAlignFa: TextAlign.end,
    );
  }

  double btnNamesWidth = 100.0;

  Widget _buildCardHeaders(String text, {bool fullWidth = false}) {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      width: portraitOrientation ? width : fullWidth ? width : width / 2 - 18,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: _buildHeaderTexts(
        text,
      ),
    );
  }

  Widget _buildCardTeam1Names() {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    Container _firstInput = Container(
      width: width / 2 - 30,
      child: Row(
        children: <Widget>[
          _buildCircleAvatar(1, t1p1.avatar),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(
              t1p1.name == null ? S
                  .of(context)
                  .first : t1p1.name,
              softWrap: true,
              maxLines: 5,
              style: Theme
                  .of(context)
                  .textTheme
                  .body1,
            ),
          ),
        ],
      ),
    );

    Container _secondInput = Container(
      width: width / 2 - 30.0,
      child: Row(
        children: <Widget>[
          _buildCircleAvatar(2, t1p2.avatar),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(t1p2.name == null ? S
                .of(context)
                .second : t1p2.name,
                softWrap: true,
                maxLines: 5,
                style: Theme
                    .of(context)
                    .textTheme
                    .body1),
          ),
        ],
      ),
    );

    return Card(
      color: Theme
          .of(context)
          .cardColor,
      child: Column(
        children: <Widget>[
          _buildCardHeaders(S
              .of(context)
              .firstTeamPlayers),
          Container(
            width: portraitOrientation ? width - 20 : width / 2 - 20,
            padding: EdgeInsets.all(6.0),
            child: portraitOrientation
                ? Row(
              children: <Widget>[_firstInput, _secondInput],
            )
                : Column(
              children: <Widget>[
                _firstInput,
                SizedBox(
                  height: 4.0,
                ),
                _secondInput
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTeam2Names() {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    Container _firstInput = Container(
      width: width / 2 - 30.0,
      child: Row(
        children: <Widget>[
          _buildCircleAvatar(3, t2p1.avatar),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(t2p1.name == null ? S
                .of(context)
                .second : t2p1.name,
                softWrap: true,
                maxLines: 5,
                style: Theme
                    .of(context)
                    .textTheme
                    .body1),
          ),
        ],
      ),
    );

    Container _secondInput = Container(
      width: width / 2 - 30.0,
      child: Row(
        children: <Widget>[
          _buildCircleAvatar(4, t2p2.avatar == null ? null : t2p2.avatar),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(t2p2.name == null ? S
                .of(context)
                .second : t2p2.name,
                softWrap: true,
                maxLines: 5,
                style: Theme
                    .of(context)
                    .textTheme
                    .body1),
          ),
        ],
      ),
    );

    return Card(
      child: Column(
        children: <Widget>[
          _buildCardHeaders(S
              .of(context)
              .secondTeamPlayers),
          Container(
            width: portraitOrientation ? width - 20 : width / 2 - 30,
            padding: EdgeInsets.all(6.0),
            child: portraitOrientation
                ? Row(
              children: <Widget>[
                _firstInput,
                _secondInput,
              ],
            )
                : Column(
              children: <Widget>[
                _firstInput,
                SizedBox(
                  height: 4.0,
                ),
                _secondInput,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInitPoints() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    Widget _firstItem = Container(
      width: width / 2 - 70,
      child: TextField(
          controller: _t1InitPointController,
          decoration: InputDecoration(labelText: S
              .of(context)
              .firstTeamPoints),
          keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: false)),
    );

    Widget _secondItem = Container(
      width: width / 2 - 70,
      child: TextField(
        controller: _t2InitPointController,
        decoration: InputDecoration(labelText: S
            .of(context)
            .secondTeamPoints),
        keyboardType:
        TextInputType.numberWithOptions(signed: true, decimal: false),
      ),
    );

    return Padding(
      padding: portraitOrientation
          ? const EdgeInsets.all(0.0)
          : const EdgeInsets.only(left: 4.0),
      child: Card(
        color: Theme
            .of(context)
            .cardColor,
        child: Column(
          children: <Widget>[
            _buildCardHeaders(S
                .of(context)
                .initPointsOptional,
                fullWidth: true),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _firstItem,
                  SizedBox(
                    width: 24,
                  ),
                  _secondItem,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTypeChips(String text, int value) {
    return ChipTheme(
      data: Theme
          .of(context)
          .chipTheme,
      child: ChoiceChip(
        label: Text(text),
        selected: _gameTypeChipValue == value,
        onSelected: (bool selected) {
          setState(() {
            _gameTypeChipValue = value;
            _setGameType(_gameTypeChipValue);
          });
        },
      ),
    );
  }

  Widget _buildGetPointsChips(String text, int value) {
    return ChipTheme(
      data: Theme.of(context).chipTheme,
      child: ChoiceChip(
        label: Text(text),
        selected: _getPointsChipValue == value,
        onSelected: (bool selected) {
          setState(() {
            _getPointsChipValue = value;
            _setGetPointsAfter(_getPointsChipValue);
          });
        },
      ),
    );
  }

  Widget _buildCardGameType() {
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildCardHeaders(S
                .of(context)
                .gameType),
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildGameTypeChips('165', 1),
                    _buildGameTypeChips('185', 2),
                    _buildGameTypeChips('200', 3),
                    _buildGameTypeChips('225', 4),
                    _buildGameTypeChips('230', 5),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildCardDouble() {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          _buildCardHeaders(S.of(context).doubleOptions),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20.0,
            children: <Widget>[
              InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade500,
                ),
                label: Text(S.of(context).doublePos),
                selected: _doublePosValue == 1,
                onSelected: (bool selected) {
                  setState(() {
                    _doublePosValue = selected ? 1 : 0;
                  });
                },
              ),
              InputChip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.grey.shade500,
                ),
                label: Text(S.of(context).doubleNeg),
                selected: _doubleNegValue == 1,
                onSelected: (bool selected) {
                  setState(() {
                    _doubleNegValue = selected ? 1 : 0;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCardResetButtons(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          _buildCardHeaders(S
              .of(context)
              .deleteFormDefaultValues),
          MyButton(
            S.of(context).clearMemory,
            Icons.delete,
            () {
              _deleteSharedPreferences(context);
            },
            iconBackColor: Theme.of(context).accentColor,
            iconColor: Colors.white,
            splashColor: Colors.white,
            width: 170.0,
            height: 32.0,
          ),
        ],
      ),
    );
  }

  Widget _buildGetPointsAfter1100() {
    return Card(
      child: Column(
        children: <Widget>[
          _buildCardHeaders(S
              .of(context)
              .getPointsAfter1100),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 10.0,
            children: <Widget>[
              _buildGetPointsChips(S
                  .of(context)
                  .write, 1),
              _buildGetPointsChips(S
                  .of(context)
                  .doNotWrite, 2),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).newGame),
      ),
      drawer: SideDrawer(),
      body: portraitOrientation
          ? Builder(
        builder: (context) =>
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 4.0, right: 8.0, left: 8.0, bottom: 8.0),
                    child: Center(
                      child: ListView(
                        children: <Widget>[
                          _buildCardTeam1Names(),
                          _buildCardTeam2Names(),
                          _buildCardDouble(),
                          _buildCardGameType(),
                          _buildGetPointsAfter1100(),
                          _buildCardInitPoints(),
                          _buildCardResetButtons(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      )
          : Builder(
        builder: (context) =>
            Column(children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 4.0, right: 8.0, left: 8.0, bottom: 8.0),
                  child: Center(
                    child: ListView(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _buildCardTeam1Names(),
                            _buildCardTeam2Names(),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            _buildCardGameType(),
                            _buildCardDouble(),
                          ],
                        ),
                        _buildCardInitPoints(),
                        Row(
                          children: <Widget>[
                            _buildGetPointsAfter1100(),
                            _buildCardResetButtons(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onStartButtonPress(),
        backgroundColor: Color(0xFFF17532),
        child: Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBarNewGame(),
    );
  }

  Widget _buildCircleAvatar(int index, String avatar) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      radius: 25.0,
      child: avatar == null
          ? IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.of(context)
                    .push<PlayerTable>(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectPlayer(),
                  ),
                )
                    .then(
                  (PlayerTable player) {
                    if (player.id != null) {
                      setState(
                        () {
                          switch (index) {
                            case 1:
                              t1p1 = player;
                              break;
                            case 2:
                              t1p2 = player;
                              break;
                            case 3:
                              t2p1 = player;
                              break;
                            case 4:
                              t2p2 = player;
                              break;
                          }
                        },
                      );
                    }
                  },
                );
              },
              iconSize: 30.0,
              color: Colors.white,
            )
          : GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push<PlayerTable>(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SelectPlayer(),
                  ),
                )
                    .then(
                  (PlayerTable player) {
                    if (player.id != null) {
                      setState(
                        () {
                          switch (index) {
                            case 1:
                              t1p1 = player;
                              break;
                            case 2:
                              t1p2 = player;
                              break;
                            case 3:
                              t2p1 = player;
                              break;
                            case 4:
                              t2p2 = player;
                              break;
                          }
                        },
                      );
                    }
                  },
                );
              },
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.topCenter,
                    image: FileImage(File(avatar)),
                  ),
                ),
              ),
            ),
    );
  }

  _deleteSharedPreferences(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    bool isDeleted = await pref.clear();

    if (!isDeleted) {
      createSnackBar(context, S.of(context).failedToRemovePrefMemory);
    } else {
      createSnackBar(context, S.of(context).reloadPageToSeeChanges);
    }
  }

  void createSnackBar(BuildContext context, String message) {
    final snackBar = new SnackBar(content: new Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();

    _t1InitPointController = TextEditingController(text: '');
    _t2InitPointController = TextEditingController(text: '');

    _t1InitPointController.addListener(_t1InitPointListener);
    _t2InitPointController.addListener(_t2InitPointListener);

    _loadSharedPreferences();

    switch (_gameTypeChipValue) {
      case 1:
        _gameType = '165';
        break;
      case 2:
        _gameType = '185';
        break;
      case 3:
        _gameType = '200';
        break;
      case 4:
        _gameType = '230';
        break;
    }

    switch (_getPointsChipValue) {
      case 1:
        _getAfter = true;
        break;
      case 2:
        _getAfter = false;
        break;
    }
  }

  _t1InitPointListener() {
    t1InitPoints = _t1InitPointController.text;
  }

  _t2InitPointListener() {
    t2InitPoints = _t2InitPointController.text;
  }

  _onStartButtonPress() {
    if (t1p1.id == null ||
        t1p2.id == null ||
        t2p1.id == null ||
        t2p2.id == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(S.of(context).selectAllPlayerNames),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text(S.of(context).ok))
            ],
          );
        },
      );
    } else if (t1p1.id == t1p2.id ||
        t1p1.id == t2p1.id ||
        t1p1.id == t2p2.id ||
        t1p2.id == t2p1.id ||
        t1p2.id == t2p2.id ||
        t2p1.id == t2p2.id) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(S.of(context).youChooseSamePlayers),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text(S.of(context).ok))
            ],
          );
        },
      );
    } else if (_gameType == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).selectGameType),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text(S.of(context).ok))
            ],
          );
        },
      );
    } else {
      if (t1InitPoints == null) {
        t1InitPoints = '0';
      }
      if (t2InitPoints == null) {
        t2InitPoints = '0';
      }

      _saveSharedPreferences();

      Map<String, dynamic> gameData;
      gameData = {
        't1p1': t1p1,
        't1p2': t1p2,
        't2p1': t2p1,
        't2p2': t2p2,
        'gameType': _gameType,
        'dPos': _doublePosValue == 1 ? true : false,
        'dNeg': _doubleNegValue == 1 ? true : false,
        't1InitPoints': t1InitPoints,
        't2InitPoints': t2InitPoints,
        'getPointsAfter': _getAfter,
      };

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => InGamePage(gameData)));
//      Navigator.of(context).push(_createRoute(gameData));
    }
  }

//Animation route transition
//  Route _createRoute(Map<String, dynamic> gameData) {
//    return PageRouteBuilder(
//      pageBuilder: (context, animation, secondaryAnimation) =>
//          InGamePage(gameData),
//      transitionsBuilder: (context, animation, secondaryAnimation, child) {
//        var begin = Offset(0.0, 1.0);
//        var end = Offset.zero;
//        var curve = Curves.ease;
//
//        var tween =
//            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//        return SlideTransition(
//          position: animation.drive(tween),
//          child: child,
//        );
//      },
//    );
//  }
}
