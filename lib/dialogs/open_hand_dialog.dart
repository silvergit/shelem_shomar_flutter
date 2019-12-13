import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/models/constants.dart';
import 'package:shelem_shomar/models/player_table.dart';

class OpenHandDialog extends StatefulWidget {
  final String title;
  final int gameType;
  final int team1Points;
  final int team2Points;
  final PlayerTable t1p1;
  final PlayerTable t1p2;
  final PlayerTable t2p1;
  final PlayerTable t2p2;

  OpenHandDialog(this.title, this.gameType, this.team1Points, this.team2Points,
      this.t1p1, this.t1p2, this.t2p1, this.t2p2);

  @override
  State<StatefulWidget> createState() {
    return _OpenHandDialogState();
  }
}

class _OpenHandDialogState extends State<OpenHandDialog> {
  int _radioGroupValue = 1;

  bool _shelemCheck = false;
  bool _konsCheck = false;

  String readPoints = '1';

  bool btn1 = true;
  bool btn2 = true;
  bool btn3 = true;
  bool btn4 = true;
  bool btn5 = true;
  bool btn6 = true;
  bool btn7 = true;
  bool btn8 = true;
  bool btn9 = true;
  bool btn0 = true;
  bool btnOk = false;

  _updateButtonsState() {
    if (readPoints.length == 1) {
      btn1 = true;
      btn2 = true;
      btn3 = true;
      btn4 = true;
      btn5 = true;
      btn6 = true;
      btn7 = true;
      btn8 = true;
      btn9 = true;
      btn0 = true;
      btnOk = false;
    } else if (readPoints.length == 2) {
      btn1 = false;
      btn2 = false;
      btn3 = false;
      btn4 = false;
      btn5 = true;
      btn6 = false;
      btn7 = false;
      btn8 = false;
      btn9 = false;
      btn0 = true;
      btnOk = false;
    } else if (readPoints.length == 3 ||
        readPoints == 'Shelem' ||
        readPoints == 'Kons') {
      btn1 = false;
      btn2 = false;
      btn3 = false;
      btn4 = false;
      btn5 = false;
      btn6 = false;
      btn7 = false;
      btn8 = false;
      btn9 = false;
      btn0 = false;
      btnOk = true;
    }
  }

  _updateReadPoints(String text) {
    if (text == 'C') {
      if (int.tryParse(readPoints) == null) {
        readPoints = '1';
        _shelemCheck = false;
        _konsCheck = false;
      }
      if (readPoints.length > 1) {
        readPoints = readPoints.substring(0, readPoints.length - 1);
      } else if (readPoints.length == 1) {
        readPoints = '1';
      }
    } else if (readPoints.length == 0) {
      readPoints = '1';
      int gp = int.parse(readPoints);
      readPoints = gp.toString();
    } else if (readPoints.length > 0 && readPoints.length < 3) {
      readPoints += text;
      int gp = int.parse(readPoints);
      readPoints = gp.toString();
    }
  }

  void _onButtonsPress(text) {
    setState(() {
      _updateReadPoints(text);
      _updateButtonsState();
    });
  }

  Widget _buildSmallButtons(String text, bool btnNum) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    bool portrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    return GestureDetector(
      onTap: (btnNum) ? () => _onButtonsPress(text) : null,
      child: Container(
        width: portrait ? width / 8 : height / 8,
        height: portrait ? width / 8 : height / 8,
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            border: Border.all(color: Theme
                .of(context)
                .accentColor),
            borderRadius: BorderRadius.all(Radius.circular(2.0))),
        child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            )),
      ),
    );

    return ButtonTheme(
      minWidth: 14.0,
      height: 48.0,
      child: OutlineButton(
        borderSide:
        BorderSide(color: Theme
            .of(context)
            .accentColor, width: 2.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: (btnNum) ? () => _onButtonsPress(text) : null,
      ),
    );
  }

  Widget _buildButtonC() {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    bool portrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    return GestureDetector(
      onTap: () {
        _onButtonsPress('C');
      },
      child: Container(
        padding: EdgeInsets.all(portrait ? width / 20 : height / 30),
        decoration: BoxDecoration(
            border: Border.all(color: Theme
                .of(context)
                .accentColor),
            borderRadius: BorderRadius.all(Radius.circular(2.0))),
        child: Center(
            child: Text(
              'C',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget _buildBtnCancel() {
    return FlatButton(
      child: Text(S.of(context).cancel),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBtnOk() {
    return FlatButton(
      child: Text(S.of(context).ok),
      onPressed: () {
        if (readPoints != 'Shelem' &&
            readPoints != 'Kons' &&
            readPoints.length < 3) {
          return null;
        } else {
          int irp;
          String rp = '';

          irp = int.tryParse(readPoints);

          if (irp == null) {
            if (readPoints == 'Shelem') {
              rp = 'Slm';
            } else if (readPoints == 'Kons') {
              rp = 'Kns';
            }
          } else {
            if (irp % 5 != 0) {
              _showAlertDialog(context, S.of(context).readPointsIsIncorrect);
            } else if (irp > widget.gameType) {
              _showAlertDialog(
                  context,
                  S.of(context).readPointsMustBeEqualOrSmallerThan(
                      widget.gameType.toString()));
            } else {
              rp = readPoints;
            }
          }

          if (rp.isNotEmpty) {
            Map<String, dynamic> sentMap = {
              'readPoints': rp,
              'shelem': _shelemCheck,
              'kons': _konsCheck,
              'starter': _radioGroupValue,
            };
            Navigator.pop(context, sentMap);
          }
        }
      },
    );
  }

  void _showAlertDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).ok),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void _onCheckboxShelemChanged(bool value) => setState(() {
        _shelemCheck = value;
        if (value) {
          readPoints = 'Shelem';
        } else {
          readPoints = '1';
        }
        _updateButtonsState();
      });

  void _onCheckboxKonsChanged(bool value) {
    setState(
      () {
        if (widget.team1Points > 1000 && widget.team2Points > 1000) {
          _konsCheck = value;
          if (value) {
            readPoints = 'Kons';
          } else {
            readPoints = '1';
          }
          _updateButtonsState();
        } else {
          _showAlertDialog(context,
              S.of(context).forReadKONSBothTeamPointsMustBeGreaterThen1000);
        }
      },
    );
  }

  void _setRadioValue(int value) => setState(() => _radioGroupValue = value);

  Widget _buildCheckRadioText(String text) {
    return new Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Widget _buildCircleAvatar() {
    return Positioned(
      left: Constants.PADDING,
      right: Constants.PADDING,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        radius: Constants.AVATAR_RADIUS,
        child: Text(
          readPoints,
          style: TextStyle(
              fontSize: (readPoints == 'Shelem' || readPoints == 'Kons')
                  ? 20.0
                  : 28.0,
              color: Theme.of(context).textTheme.body1.color),
        ),
      ),
    );
  }

  _portraitDialogContent(BuildContext context) {
    Widget _numPadItems = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSmallButtons('1', btn1),
            SizedBox(width: 10.0),
            _buildSmallButtons('2', btn2),
            SizedBox(width: 10.0),
            _buildSmallButtons('3', btn3),
            SizedBox(width: 10.0),
            _buildSmallButtons('4', btn4),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSmallButtons('5', btn5),
            SizedBox(width: 10.0),
            _buildSmallButtons('6', btn6),
            SizedBox(width: 10.0),
            _buildSmallButtons('7', btn7),
            SizedBox(width: 10.0),
            _buildSmallButtons('8', btn8),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSmallButtons('9', btn9),
            SizedBox(width: 10.0),
            _buildSmallButtons('0', btn0),
            SizedBox(width: 10.0),
            _buildButtonC(),
            SizedBox(width: 10.0),
            SizedBox(
              width: 46.0,
            ),
          ],
        ),
      ],
    );

    Widget _namesAndAvatars = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 1,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t1p1.name),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 3,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t2p1.name),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 2,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t1p2.name),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 4,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t2p2.name),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );

    Widget _radioItems = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(value: _shelemCheck, onChanged: _onCheckboxShelemChanged),
            _buildCheckRadioText(S
                .of(context)
                .shelem),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(value: _konsCheck, onChanged: _onCheckboxKonsChanged),
            _buildCheckRadioText(S
                .of(context)
                .kons),
          ],
        ),
      ],
    );

    Widget _okCancelButtons = Row(
      children: <Widget>[
        SizedBox(width: 10),
        _buildBtnOk(),
        SizedBox(width: 20),
        _buildBtnCancel(),
        SizedBox(width: 10),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Constants.AVATAR_RADIUS + Constants.PADDING,
            bottom: Constants.PADDING,
            left: Constants.PADDING,
            right: Constants.PADDING,
          ),
          margin: EdgeInsets.only(top: Constants.AVATAR_RADIUS),
          decoration: new BoxDecoration(
            color: Theme
                .of(context)
                .cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Constants.PADDING),
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .secondaryHeaderColor,
                blurRadius: 10.0,
                offset: const Offset(1.0, 2.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    _numPadItems,
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),
                    _namesAndAvatars,
                    Divider(),
                    _radioItems,
                    Divider(
                      color: Theme
                          .of(context)
                          .secondaryHeaderColor,
                    ),
                    _okCancelButtons,
                  ],
                )),
          ),
        ),
        _buildCircleAvatar(),
      ],
    );
  }

  _landDialogContent(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    Widget _numPadItems = Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSmallButtons('1', btn1),
            SizedBox(width: 10.0),
            _buildSmallButtons('2', btn2),
            SizedBox(width: 10.0),
            _buildSmallButtons('3', btn3),
            SizedBox(width: 10.0),
            _buildSmallButtons('4', btn4),
            SizedBox(width: 10.0),
            _buildSmallButtons('5', btn5),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSmallButtons('6', btn6),
            SizedBox(width: 4.0),
            _buildSmallButtons('7', btn7),
            SizedBox(width: 4.0),
            _buildSmallButtons('8', btn8),
            SizedBox(width: 4.0),
            _buildSmallButtons('9', btn9),
            SizedBox(width: 4.0),
            _buildSmallButtons('0', btn0),
            SizedBox(width: 4.0),
            _buildButtonC(),
          ],
        ),
      ],
    );

    Widget _namesAndAvatars = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: width / 6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 1,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t1p1.name),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Container(
              width: width / 6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 2,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t1p2.name),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 3,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t2p1.name),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Container(
              width: width / 6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: 4,
                        groupValue: _radioGroupValue,
                        onChanged: _setRadioValue),
                    _buildCheckRadioText(widget.t2p2.name),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );

    Widget _radioItems = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(value: _shelemCheck, onChanged: _onCheckboxShelemChanged),
            _buildCheckRadioText(S
                .of(context)
                .shelem),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(value: _konsCheck, onChanged: _onCheckboxKonsChanged),
            _buildCheckRadioText(S
                .of(context)
                .kons),
          ],
        ),
      ],
    );

    Widget _okCancelButtons = Row(
      children: <Widget>[
        SizedBox(width: 10),
        _buildBtnOk(),
        SizedBox(width: 20),
        _buildBtnCancel(),
        SizedBox(width: 10),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Constants.AVATAR_RADIUS + Constants.PADDING,
            bottom: Constants.PADDING,
            left: Constants.PADDING,
            right: Constants.PADDING,
          ),
          margin: EdgeInsets.only(top: Constants.AVATAR_RADIUS),
          decoration: new BoxDecoration(
            color: Theme
                .of(context)
                .cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Constants.PADDING),
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .secondaryHeaderColor,
                blurRadius: 10.0,
                offset: const Offset(1.0, 2.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Container(
                child: Container(
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              _numPadItems,
                              SizedBox(
                                height: 10.0,
                              ),
                              _okCancelButtons,
                            ],
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                _namesAndAvatars,
                                SizedBox(
                                  height: 10.0,
                                ),
                                _radioItems,
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Divider(
                                color: Theme
                                    .of(context)
                                    .secondaryHeaderColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
        _buildCircleAvatar(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.PADDING),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _portraitDialogContent(context)
            : _landDialogContent(context);
      }),
    );
  }
}
