import 'package:flutter/material.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/models/constants.dart';

class CloseHandDialog extends StatefulWidget {
  final String title;
  final int gameType;

  CloseHandDialog(
    this.title,
    this.gameType,
  );

  @override
  State<StatefulWidget> createState() {
    return _CloseHandDialogState();
  }
}

class _CloseHandDialogState extends State<CloseHandDialog> {
  String getPoints = '0';

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
    if (getPoints.length == 1) {
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
    } else if (getPoints.length == 2) {
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
    } else if (getPoints.length == 3) {
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

  _updateGetPoints(String text) {
    if (text == 'C') {
      if (getPoints.length > 1) {
        getPoints = getPoints.substring(0, getPoints.length - 1);
      } else if (getPoints.length == 1) {
        getPoints = '0';
      }
    } else if (getPoints.length == 0) {
      getPoints = '1';
      int gp = int.parse(getPoints);
      getPoints = gp.toString();
    } else if (getPoints.length > 0 && getPoints.length < 3) {
      getPoints += text;
      int gp = int.parse(getPoints);
      getPoints = gp.toString();
    }
  }

  _onButtonsPress(text) {
    setState(() {
      _updateGetPoints(text);
      _updateButtonsState();
    });
  }

  Widget _buildSmallButtons(String text, bool btnNum) {
    return ButtonTheme(
      minWidth: 14.0,
      height: 48.0,
      child: OutlineButton(
        borderSide: BorderSide(color: Theme.of(context).accentColor),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: (btnNum) ? () => _onButtonsPress(text) : null,
      ),
    );
  }

  Widget _buildButtonC() {
    return ButtonTheme(
      minWidth: 14.0,
      height: 48.0,
      child: OutlineButton(
        child: Text(
          'C',
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          _onButtonsPress('C');
        },
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
        int gp = int.parse(getPoints);
        if (gp >= widget.gameType) {
          _showAlertDialog(
              context,
              S
                  .of(context)
                  .getPointsMustBeSmallerThan(widget.gameType.toString()));
        } else if (gp % 5 == 0 && int.parse(getPoints) < widget.gameType) {
          Navigator.pop(context, getPoints);
        }
        if (gp % 5 != 0) {
          _showAlertDialog(context, S.of(context).getPointsIsIncorrect);
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

  dialogContent(BuildContext context) {
    bool portraitOrientation =
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait;

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

    Widget _okCancelButtons = portraitOrientation ? Row(
      children: <Widget>[
        SizedBox(width: 10),
        Expanded(child: _buildBtnOk()),
        SizedBox(width: 20),
        Expanded(child: _buildBtnCancel()),
        SizedBox(width: 10),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    ) : Column(
      children: <Widget>[
        _buildBtnOk(),
        SizedBox(height: 20),
        _buildBtnCancel(),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );

    Widget _circleAvatars = Positioned(
      left: Constants.PADDING,
      right: Constants.PADDING,
      child: CircleAvatar(
        backgroundColor: Theme
            .of(context)
            .accentColor,
        radius: Constants.AVATAR_RADIUS,
        child: Text(
          getPoints,
          style: TextStyle(fontSize: 28.0),
        ),
      ),
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
          child: portraitOrientation
              ? Column(
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
              _okCancelButtons,
            ],
          )
              : Row(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
//                    Text(
//                      widget.title,
//                      style: TextStyle(
//                        fontSize: 24.0,
//                        fontWeight: FontWeight.w700,
//                      ),
//                    ),
//                    SizedBox(height: 16.0),
              _numPadItems,
              SizedBox(
                width: 10.0,
              ),
//                    Divider(),
              _okCancelButtons,
            ],
          ),
        ),
        _circleAvatars,
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
      child: dialogContent(context),
    );
  }
}
