import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPress;
  final double width;
  final double height;
  final double margin;
  final double borderWidth;
  final Color borderColor;
  final Color backColor;
  final Color splashColor;
  final double borderRadius;
  final double fontSize;
  final Color fontColor;
  final Color iconColor;
  final double iconSize;
  final Color iconBackColor;
  Locale myLocale;

  MyButton(this.text, this.icon, this.onPress,
      {this.width = double.infinity,
      this.height = 42.0,
      this.margin = 8.0,
      this.borderWidth = 1.0,
      this.borderRadius = 10.0,
      this.borderColor,
      this.backColor,
      this.splashColor,
      this.fontSize,
      this.fontColor,
      this.iconColor,
      this.iconBackColor,
      this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    myLocale = Localizations.localeOf(context);

    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
              color: backColor,
              border: Border.all(
                  width: borderWidth,
                  color: borderColor == null
                      ? Theme.of(context).accentColor
                      : borderColor),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Row(
            children: <Widget>[
              Container(
                height: height,
                width: iconSize + 20,
                decoration: BoxDecoration(
                  borderRadius: myLocale.languageCode == 'fa'
                      ? BorderRadius.only(
                          topRight: Radius.circular(borderRadius - 1),
                          bottomRight: Radius.circular(borderRadius - 1))
                      : BorderRadius.only(
                          topLeft: Radius.circular(borderRadius - 1),
                          bottomLeft: Radius.circular(borderRadius - 1)),
                  color: iconBackColor,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: fontSize, color: fontColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: Container(
            margin: EdgeInsets.all(margin),
            width: width,
            height: height,
            child: InkWell(
              onTap: onPress,
              splashColor: splashColor == null
                  ? Theme
                  .of(context)
                  .accentColor
                  .withOpacity(0.1)
                  : splashColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
