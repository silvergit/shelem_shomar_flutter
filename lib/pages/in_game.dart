import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jalali_date/jalali_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelem_shomar/ListView/chart_listview.dart';
import 'package:shelem_shomar/Widgets/bottom-bar-ingame.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';
import 'package:shelem_shomar/dialogs/close_hand_dialog.dart';
import 'package:shelem_shomar/dialogs/open_hand_dialog.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';
import 'package:shelem_shomar/models/constants.dart';
import 'package:shelem_shomar/models/game_table.dart';
import 'package:shelem_shomar/models/in_game_list_item.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/models/points_table.dart';
import 'package:shelem_shomar/models/win_loss_table.dart';
import 'package:shelem_shomar/pages/winner_details.dart';

class InGamePage extends StatefulWidget {
  final Map<String, dynamic> gameData;

  InGamePage(this.gameData);

  @override
  State<StatefulWidget> createState() {
    return _InGamePage();
  }
}

class _InGamePage extends State<InGamePage>
    with SingleTickerProviderStateMixin {
  //INIT
  List<Item> listItems = [];
  bool _changeButtonOpenCloseText = true;
  bool btnGameState = true;
  int _starter = 0;
  bool _isShelem = false;
  bool _isKons = false;
  String _readPoints;
  int _getPoints;
  int _dPosCount = 0;
  int _dNegCount = 0;
  String _date = PersianDate.now().toString();
  String _time = '0:0:0';
  String _team1PointsResult = '0';
  String _team2PointsResult = '0';
  int _winner;
  PlayerTable _t1p1 = PlayerTable();
  PlayerTable _t1p2 = PlayerTable();
  PlayerTable _t2p1 = PlayerTable();
  PlayerTable _t2p2 = PlayerTable();
  List<PlayerReadRecords> _playerReadRecords = [];
  PlayerReadRecords _prr1;
  PlayerReadRecords _prr2;
  PlayerReadRecords _prr3;
  PlayerReadRecords _prr4;
  DateTime _startTime;
  Timer _timer;
  int _listTypeIndex;
  bool _getAfter = false;

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    if (widget.gameData['t1InitPoints'] != '0' ||
        widget.gameData['t2InitPoints'] != '0') {
      _buildDefaultListItem(
          widget.gameData['t1InitPoints'], widget.gameData['t2InitPoints']);
    }

    _t1p1 = widget.gameData['t1p1'];
    _t1p2 = widget.gameData['t1p2'];
    _t2p1 = widget.gameData['t2p1'];
    _t2p2 = widget.gameData['t2p2'];

    _prr1 = PlayerReadRecords(_t1p1.name, _t1p1.avatar);
    _prr2 = PlayerReadRecords(_t1p2.name, _t1p2.avatar);
    _prr3 = PlayerReadRecords(_t2p1.name, _t2p1.avatar);
    _prr4 = PlayerReadRecords(_t2p2.name, _t2p2.avatar);

    _startTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTimer());

    _getAfter = widget.gameData['getPointsAfter'];

    _loadSharedPreferences();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  //NORMAL FUNCTIONS
  void _updateListTypeIndex() {
    int maxIndex = 2;
    if (_listTypeIndex + 1 > maxIndex)
      setState(() {
        _listTypeIndex = 0;
      });
    else
      setState(() {
        _listTypeIndex++;
      });
    _saveSharedPreferences();
  }

  void _updateTimer() {
    DateTime endTime = DateTime.now();
    Duration duration = endTime.difference(_startTime);
    String sDuration =
        "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
    setState(() {
      _time = sDuration;
    });
  }

  int _getGoalPoint() {
    int gType = int.parse(widget.gameData['gameType']);

    int gPoint = 0;
    switch (gType) {
      case 165:
        gPoint = 1165;
        break;
      case 185:
        gPoint = 1185;
        break;
      case 200:
        gPoint = 1200;
        break;
      case 230:
        gPoint = 1230;
    }
    return gPoint;
  }

  void _changeButtonText() {
    setState(() {
      _changeButtonOpenCloseText = !_changeButtonOpenCloseText;
    });
  }

  void _updateTextViewResults() {
    int t1Sum = _getSumListRows(1);
    int t2Sum = _getSumListRows(2);

    setState(() {
      _team1PointsResult = t1Sum.toString();
      _team2PointsResult = t2Sum.toString();
    });
  }

  int _getSumListRows(int teamNumber) {
    int sum = 0;

    for (Item item in listItems) {
      if (teamNumber == 1) {
        var t1 = int.tryParse(item.team1HandPoints);
        t1 == null ? sum += 0 : sum += t1;
      } else if (teamNumber == 2) {
        var t2 = int.tryParse(item.team2HandPoints);
        t2 == null ? sum += 0 : sum += t2;
      }
    }

    return sum;
  }

  void _removeLastItemFromListView() {
    setState(() {
      listItems.removeLast();
    });
  }

  bool _checkForWin(int t1SumListRows, int t2SumListRows) {
    _winner = -1; //1 for first team and 2 for second team
    bool isWin = false;

    if (t1SumListRows >= _getGoalPoint()) {
      _winner = 1;
      btnGameState = false;
      _createWinnerDialog(context, _winner, "nrm");
      isWin = true;
    } else if (t2SumListRows >= _getGoalPoint()) {
      _winner = 2;
      btnGameState = false;
      _createWinnerDialog(context, _winner, "nrm");
      isWin = true;
    } else if (t1SumListRows > t2SumListRows) {
      if (t1SumListRows - t2SumListRows >= _getGoalPoint()) {
        _winner = 1;
        btnGameState = false;
        _createWinnerDialog(context, _winner, "dif");
        isWin = true;
      }
    } else if (t1SumListRows < t2SumListRows) {
      if (t2SumListRows - t1SumListRows >= _getGoalPoint()) {
        _winner = 2;
        btnGameState = false;
        _createWinnerDialog(context, _winner, "dif");
        isWin = true;
      }
    }
    return isWin;
  }

  void _createWinnerDialog(BuildContext context, int winner, String flag) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            S.of(context).gameOver,
            style: Theme.of(context).textTheme.body2,
          ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200.0,
                  child: OutlineButton(
                    child: Text(S.of(context).backToGame),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  width: 200.0,
                  child: OutlineButton(
                    child: Text(S.of(context).quitAndSaveGame),
                    onPressed: () {
                      _playerReadRecords.add(_prr1);
                      _playerReadRecords.add(_prr2);
                      _playerReadRecords.add(_prr3);
                      _playerReadRecords.add(_prr4);

                      _addGameDataToDb();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => WinnerDetails(
                                  _playerReadRecords,
                                  _winner,
                                  listItems.length,
                                  _dPosCount,
                                  _dNegCount,
                                  _getSumListRows(1),
                                  _getSumListRows(2),
                                  _time)));
                    },
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void _setBtnStartState(bool state) {
    setState(
          () {
        btnGameState = state;
      },
    );
  }

  //ASYNC FUNCTIONS

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text(S
            .of(context)
            .areYouSure),
        content: new Text(S
            .of(context)
            .doYouWantToExit),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(S
                .of(context)
                .no),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(S
                .of(context)
                .yes),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _saveSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('listType', _listTypeIndex);
  }

  void _loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('listType') != null) {
      setState(() {
        _listTypeIndex = prefs.getInt('listType');
      });
    } else {
      setState(() {
        _listTypeIndex = 0;
      });
    }
  }

  _addGameDataToDb() async {
    int p1Id = widget.gameData['t1p1'].id;
    int p2Id = widget.gameData['t1p2'].id;
    int p3Id = widget.gameData['t2p1'].id;
    int p4Id = widget.gameData['t2p2'].id;

    //InsertGame
    int gameId = await _addGameToDB(p1Id, p2Id, p3Id, p4Id);
    //Insert points
    _addPointsToDB(gameId);

    //Insert states
    switch (_winner) {
      case 1:
        _addStateToDb(gameId, p1Id, 1);
        _addStateToDb(gameId, p2Id, 1);
        _addStateToDb(gameId, p3Id, 0);
        _addStateToDb(gameId, p4Id, 0);
        break;
      case 2:
        _addStateToDb(gameId, p1Id, 0);
        _addStateToDb(gameId, p2Id, 0);
        _addStateToDb(gameId, p3Id, 1);
        _addStateToDb(gameId, p4Id, 1);
        break;
    }
  }

  Future<int> _addGameToDB(int p1Id, int p2Id, int p3Id, int p4Id) async {
    //Insert game
    GameTable game = GameTable();
    game.player1Id = p1Id;
    game.player2Id = p2Id;
    game.player3Id = p3Id;
    game.player4Id = p4Id;
    game.date = _date;
    game.time = _time;
    game.team1Points = _getSumListRows(1);
    game.team2Points = _getSumListRows(2);
    game.gameType = int.parse(widget.gameData['gameType']);

    var db = DBHelper();

    int id = await db.addGame(game);

    return id;
  }

  Future _addPointsToDB(int gameId) async {
    var db = DBHelper();

    for (int i = 0; i < listItems.length; i++) {
      PointsTable point = PointsTable();
      point.gameId = gameId;
      point.team1Points = listItems[i].team1HandPoints;
      point.team2Points = listItems[i].team2HandPoints;
      point.readPoints = listItems[i].readPoints;
      point.starter = listItems[i].starter;
      point.whichColor = listItems[i].whichColor;

      await db.addPoints(point);
    }
  }

  Future _addStateToDb(int gameId, int playerId, int state) async {
    WinLossTable wlState = WinLossTable();
    wlState.gameId = gameId;
    wlState.playerId = playerId;
    wlState.state = state;

    var db = DBHelper();
    await db.addWinLossState(wlState);
  }

  //WIDGETS
  Widget _buildHeader(String languageCode) {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    Widget _finalPoints = Row(
      children: <Widget>[
        Text(
          '${S
              .of(context)
              .finalPoints}: ',
          style: TextStyle(fontSize: 20.0),
        ),
        TextWithLocale(
          _getGoalPoint().toString(),
          languageCode,
          fontSize: 16.0,
        )
      ],
    );

    Widget _timeText = TextWithLocale(
      _time,
      languageCode,
      fontSize: 16.0,
    );

    Widget _dateText = TextWithLocale(
      _date,
      languageCode,
      fontSize: 16.0,
    );

    Widget _avatarsAndScores = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextWithLocale(
                _team1PointsResult,
                languageCode,
                textAlignEn: TextAlign.start,
                textAlignFa: TextAlign.end,
                fontSize: 20.0,
              ),
            ),
            CustomCircleAvatar(
              _t1p1.avatar,
              radius: 20.0,
              iconSize: 25.0,
            ),
            SizedBox(
              width: 12.0,
            ),
            CustomCircleAvatar(
              _t1p2.avatar,
              radius: 20.0,
              iconSize: 25.0,
            ),
          ],
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextWithLocale(
                _team2PointsResult,
                languageCode,
                textAlignEn: TextAlign.start,
                textAlignFa: TextAlign.end,
                fontSize: 20.0,
              ),
            ),
            CustomCircleAvatar(
              _t2p1.avatar,
              radius: 20.0,
              iconSize: 25.0,
            ),
            SizedBox(
              width: 12.0,
            ),
            CustomCircleAvatar(
              _t2p2.avatar,
              radius: 20.0,
              iconSize: 25.0,
            ),
          ],
        ),
      ],
    );

    return Container(
      width: portraitOrientation ? width : width / 3,
      height:
      portraitOrientation ? null : MediaQuery
          .of(context)
          .size
          .height - 80,
      padding: EdgeInsets.all(10.0),
      color: Theme
          .of(context)
          .accentColor,
      margin: portraitOrientation
          ? EdgeInsets.only(bottom: 10.0)
          : EdgeInsets.all(0.0),
      child: portraitOrientation
          ? Row(children: <Widget>[
        Expanded(
          child: _finalPoints,
        ),
        _timeText,
        SizedBox(
          width: 16.0,
        ),
        _dateText,
      ])
          : Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _finalPoints,
            _timeText,
            SizedBox(
              width: 16.0,
            ),
            _dateText,
            Container(
              padding: EdgeInsets.all(10.0),
              child: _avatarsAndScores,
            ),
            _createStartButtonIcon()
          ]),
    );
  }

  Widget _buildBottomResultsBar(String languageCode) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          CustomCircleAvatar(
            _t1p1.avatar,
            radius: 20.0,
            iconSize: 25.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          CustomCircleAvatar(
            _t1p2.avatar,
            radius: 20.0,
            iconSize: 25.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: TextWithLocale(
              _team1PointsResult,
              languageCode,
              textAlignEn: TextAlign.start,
              textAlignFa: TextAlign.end,
              fontSize: 20.0,
            ),
          ),
          Expanded(
            child: TextWithLocale(
              _team2PointsResult,
              languageCode,
              textAlignEn: TextAlign.end,
              textAlignFa: TextAlign.start,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          CustomCircleAvatar(
            _t2p1.avatar,
            radius: 20.0,
            iconSize: 25.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          CustomCircleAvatar(
            _t2p2.avatar,
            radius: 20.0,
            iconSize: 25.0,
          ),
        ],
      ),
    );
  }

  void _buildDefaultListItem(String t1Points, String t2Points) {
    Item item = Item();
    item.readPoints = '...';
    item.team1HandPoints = t1Points;
    item.team2HandPoints = t2Points;
    item.starter = 0;
    item.whichColor = Constants.DEFAULT_CASE;

    listItems.add(item);

    _updateTextViewResults();
  }

  void _showOpenHandDialog() {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) => OpenHandDialog(
        S.of(context).readPoints,
        int.parse(widget.gameData['gameType']),
        int.parse(_team1PointsResult),
        int.parse(_team2PointsResult),
        widget.gameData['t1p1'],
        widget.gameData['t1p2'],
        widget.gameData['t2p1'],
        widget.gameData['t2p2'],
      ),
    ).then(
      (onValue) {
        if (onValue != null) {
          _starter = onValue['starter'];
          _readPoints = onValue['readPoints'];
          _isShelem = onValue['shelem'];
          _isKons = onValue['kons'];

          _changeButtonText();
          _buildOpenHandListItem();
        }
      },
    );
  }

  void _showCloseHandDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => CloseHandDialog(
          S.of(context).getPoints, int.parse(widget.gameData['gameType'])),
    ).then(
      (onValue) {
        if (onValue != null) {
          _getPoints = int.parse(onValue);

          _changeButtonText();
          _buildCloseHandListItem();
        }
      },
    );
  }

  _buildOpenHandListItem() {
    String readPoints;
    if (_isShelem) {
      readPoints = S
          .of(context)
          .slm;
    } else if (_isKons) {
      readPoints = S
          .of(context)
          .kns;
    } else {
      readPoints = _readPoints;
    }

    Item item = Item();
    item.readPoints = readPoints;
    item.team1HandPoints = '0';
    item.team2HandPoints = '0';
    item.starter = _starter;
    item.whichColor = Constants.READ_CASE;

    setState(() {
      listItems.add(item);
    });
  }

  _buildCloseHandListItem() {
    _removeLastItemFromListView();

    String winLoos = Constants.READ_CASE;
    int readPoints = int.tryParse(_readPoints);
    int getPoints = _getPoints;
    int gameType = int.tryParse(widget.gameData['gameType']);
    int totalHands = readPoints == null ? -1 : getPoints + readPoints;
    int firstScore = 0;
    int secondScore = 0;

    bool dPos = widget.gameData['dPos'];
    bool dNeg = widget.gameData['dNeg'];

    int team1Points;
    int team2Points;

    //****Kons
    if (_isKons) {
      if (getPoints == 0) {
        firstScore = gameType * 2;
        secondScore = 0;
        winLoos = Constants.WIN_CASE;
      } else {
        firstScore = gameType * -2;
        secondScore = getPoints;
        winLoos = Constants.LOSE_CASE;
      }
    }
    //****Shelem
    else if (_isShelem) {
      //Win shelem
      if (getPoints == 0) {
        firstScore = gameType * 2;
        secondScore = 0;
        winLoos = Constants.WIN_CASE;
      } else {
        //Loose Shelem
        firstScore = gameType * -2;
        secondScore = getPoints;
        winLoos = Constants.LOSE_CASE;
      }
    }
    //****Win
    // Sample readPoints = 140, getPoints = 20, gameType = 165
    else if (totalHands <= gameType) {
      // get points = 0
      if (getPoints == 0) {
        //if double positive : winner group = 280, looser group = 0
        if (dPos) {
          {
            firstScore = readPoints * 2;
            secondScore = getPoints;
            winLoos = Constants.WIN_CASE;
            _dPosCount++;
          }
        }
        //winner group = 165, looser group = 0
        else {
          firstScore = gameType - getPoints;
          secondScore = getPoints;
          winLoos = Constants.WIN_CASE;
        }
        // winner group = 145, looser group = 20
      } else if (getPoints > 0) {
        if (_getAfter) {
          if (_starter == 1 || _starter == 2) {
            firstScore = gameType - getPoints;
            secondScore = getPoints;
            winLoos = Constants.WIN_CASE;
          } else if (_starter == 3 || _starter == 4) {
            firstScore = gameType - getPoints;
            secondScore = getPoints;
            winLoos = Constants.WIN_CASE;
          }
        } else {
          if (_starter == 1 || _starter == 2) {
            firstScore = gameType - getPoints;
            secondScore = getPoints;
            winLoos = Constants.WIN_CASE;
          } else if (_starter == 3 || _starter == 4) {
            firstScore = gameType - getPoints;
            secondScore = getPoints;
            winLoos = Constants.WIN_CASE;
          }
        }
      }
    }
    //****Loose
    // Sample readPoints = 140, getPoints = 90, gameType = 165
    else if (totalHands > gameType) {
      //if double negative :
      // winner group = 90, looser group = -280
      if (dNeg) {
        if (getPoints > gameType / 2) {
          firstScore = readPoints * -2;
          secondScore = getPoints;
          winLoos = Constants.LOSE_CASE;
          _dNegCount++;
        }
        //winner group = 90, looser group = -140
        else {
          firstScore = readPoints * -1;
          secondScore = getPoints;
          winLoos = Constants.LOSE_CASE;
        }
      }
      //winner group = 90, looser group = -240
      else {
        firstScore = readPoints * -1;
        secondScore = getPoints;
        winLoos = Constants.LOSE_CASE;
      }
    }

    String rP;
    if (_isShelem) {
      rP = S
          .of(context)
          .slm;
    } else if (_isKons) {
      rP = S
          .of(context)
          .kns;
    } else {
      rP = _readPoints;
    }

    switch (_starter) {
      case 1:
        team1Points = firstScore;
        team2Points = secondScore;
        _prr1.readCount++;
        if (_isKons)
          _prr1.topRead = 999;
        else if (_isShelem)
          _prr1.topRead = 998;
        else if (_prr1.topRead < readPoints) _prr1.topRead = readPoints;
        if (winLoos == Constants.WIN_CASE) _prr1.wins++;
        if (winLoos == Constants.LOSE_CASE) _prr1.looses++;
        break;
      case 2:
        team1Points = firstScore;
        team2Points = secondScore;
        _prr2.readCount++;
        if (_isKons)
          _prr2.topRead = 999;
        else if (_isShelem)
          _prr2.topRead = 998;
        else if (_prr2.topRead < readPoints) _prr2.topRead = readPoints;
        if (winLoos == Constants.WIN_CASE) _prr2.wins++;
        if (winLoos == Constants.LOSE_CASE) _prr2.looses++;
        break;
      case 3:
        team2Points = firstScore;
        team1Points = secondScore;
        _prr3.readCount++;
        if (_isKons)
          _prr3.topRead = 999;
        else if (_isShelem)
          _prr3.topRead = 998;
        else if (_prr3.topRead < readPoints) _prr3.topRead = readPoints;
        if (winLoos == Constants.WIN_CASE) _prr3.wins++;
        if (winLoos == Constants.LOSE_CASE) _prr3.looses++;
        break;
      case 4:
        team2Points = firstScore;
        team1Points = secondScore;
        _prr4.readCount++;
        if (_isKons)
          _prr4.topRead = 999;
        else if (_isShelem)
          _prr4.topRead = 998;
        else if (_prr4.topRead < readPoints) _prr4.topRead = readPoints;
        if (winLoos == Constants.WIN_CASE) _prr4.wins++;
        if (winLoos == Constants.LOSE_CASE) _prr4.looses++;
        break;
    }

    Item item = Item();
    item.readPoints = rP;
    item.starter = _starter;
    item.team1HandPoints = team1Points.toString();
    item.team2HandPoints = team2Points.toString();
    item.whichColor = winLoos;

    setState(() {
      listItems.add(item);
    });

    _updateTextViewResults();

    if (_isKons) {
      int _winner = -1; // 1 for team1 and 2 for team2
      if (_starter == 1 || _starter == 2) {
        if (winLoos == Constants.WIN_CASE) {
          _winner = 1;
        } else if (winLoos == Constants.LOSE_CASE) {
          _winner = 2;
        }
      } else if (_starter == 3 || _starter == 4) {
        if (winLoos == Constants.WIN_CASE) {
          _winner = 2;
        } else if (winLoos == Constants.LOSE_CASE) {
          _winner = 1;
        }
      }

      setState(() {
        btnGameState = false;
      });

      _createWinnerDialog(context, _winner, "nrm");
    } else {
      _checkForWin(_getSumListRows(1), _getSumListRows(2));
    }
  }

  //BUILD
  @override
  Widget build(BuildContext context) {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    String languageCode = Localizations
        .localeOf(context)
        .languageCode;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(S
              .of(context)
              .gameChart),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.line_style), onPressed: _updateListTypeIndex)
          ],
        ),
        drawer: SideDrawer(),
        body: portraitOrientation
            ? Column(
          children: <Widget>[
            _buildHeader(languageCode),
            Expanded(
              child: ChartListView(
                listItems,
                _t1p1,
                _t1p2,
                _t2p1,
                _t2p2,
                _setBtnStartState,
                _updateTextViewResults,
                _changeButtonOpenCloseText,
                _changeButtonText,
                _listTypeIndex,
              ),
            ),
          ],
        )
            : Row(
          children: <Widget>[
            _buildHeader(languageCode),
            Expanded(
              child: ChartListView(
                listItems,
                _t1p1,
                _t1p2,
                _t2p1,
                _t2p2,
                _setBtnStartState,
                _updateTextViewResults,
                _changeButtonOpenCloseText,
                _changeButtonText,
                _listTypeIndex,
              ),
            ),
          ],
        ),
        bottomNavigationBar: portraitOrientation
            ? BottomBarInGame(_buildBottomResultsBar(languageCode))
            : null,
        floatingActionButton: portraitOrientation
            ? FloatingActionButton(
            onPressed: () {
              if (!btnGameState)
                return null;
              else {
                if (_changeButtonOpenCloseText) {
                  _showOpenHandDialog();
                } else {
                  _showCloseHandDialog();
                }
              }
            },
            backgroundColor: Color(0xFFF17532),
            child: _createStartButtonIcon())
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _createStartButtonIcon() {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

    Widget _disableButton = portraitOrientation
        ? IconButton(
      icon: Icon(Icons.do_not_disturb_alt),
      onPressed: null,
    )
        : RaisedButton(
      elevation: 10,
      color: Theme
          .of(context)
          .accentColor,
      child: Text(S
          .of(context)
          .gameOver),
      onPressed: null,
    );

    Widget _openButton = portraitOrientation
        ? IconButton(
      icon: Icon(Icons.play_arrow),
      onPressed: _showOpenHandDialog,
    )
        : RaisedButton(
      elevation: 10,
      color: Theme
          .of(context)
          .accentColor,
      child: Text(S
          .of(context)
          .openHand),
      onPressed: _showOpenHandDialog,
    );

    Widget _closeButton = portraitOrientation
        ? IconButton(
      icon: Icon(Icons.stop),
      onPressed: _showCloseHandDialog,
    )
        : RaisedButton(
      elevation: 10,
      color: Theme
          .of(context)
          .accentColor,
      child: Text(S
          .of(context)
          .closeHand),
      onPressed: _showCloseHandDialog,
    );

    if (!btnGameState) {
      return _disableButton;
    } else {
      if (_changeButtonOpenCloseText) {
        return _openButton;
      } else {
        return _closeButton;
      }
    }
  }
}

class PlayerReadRecords {
  String name;
  String avatar;
  int readCount = 0;
  int topRead = 0;
  int wins = 0;
  int looses = 0;

  PlayerReadRecords(this.name, this.avatar);
}
