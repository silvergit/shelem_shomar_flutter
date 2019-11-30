import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/text-with-locale-support.dart';

class ScoreLabel extends StatelessWidget {
  final String score;
  final double width;
  final double height;
  final double fontSize;
  final double transparent;
  final Color fontColor;
  final double topPadding;
  final double bottomPadding;
  final double margin;
  final Color backColor;

  ScoreLabel(this.score,
      {this.width = 80.0,
      this.height = 40.0,
      this.fontSize = 25.0,
      this.transparent = 0.2,
      this.fontColor = Colors.black,
      this.topPadding = 8.0,
      this.bottomPadding = 8.0,
      this.margin = 8.0,
        this.backColor});

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations
        .localeOf(context)
        .languageCode;

    return Container(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            color: backColor == null
                ? Colors.transparent.withOpacity(transparent)
                : backColor),
        child: TextWithLocale(score, languageCode,
            fontSize: fontSize, fontColor: fontColor),
      ),
    );
  }
}
