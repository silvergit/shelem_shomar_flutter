import 'package:flutter/material.dart';

class TextWithLocale extends StatelessWidget {
  final String text;
  final String languageCode;
  final double fontSize;
  final TextAlign textAlignFa;
  final TextAlign textAlignEn;
  final Color fontColor;

  TextWithLocale(this.text, this.languageCode,
      {this.fontSize,
      this.textAlignFa = TextAlign.center,
      this.textAlignEn = TextAlign.center,
      this.fontColor});

  @override
  Widget build(BuildContext context) {
    if (languageCode == 'fa') {
      return Text(
        text,
        style: TextStyle(
            fontFamily: 'vazir', fontSize: fontSize, color: fontColor),
        textDirection: TextDirection.ltr,
        textAlign: textAlignFa,
      );
    } else {
      return Text(
        text,
        style: TextStyle(
            fontFamily: 'opensans', fontSize: fontSize, color: fontColor),
        textAlign: textAlignEn,
      );
    }
  }
}
