import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, GREEN, BLUE, GNOME }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'vazir',
    brightness: Brightness.light,
    cardColor: Colors.grey.shade200,
    accentColor: Colors.deepOrange.shade400,
    chipTheme: ChipThemeData(
      selectedColor: Colors.deepOrange.shade400,
      secondarySelectedColor: Colors.deepOrange.shade400,
      backgroundColor: Colors.grey,
      disabledColor: Colors.grey,
      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(4.0),
      shape: StadiumBorder(),
      labelStyle: TextStyle(),
      secondaryLabelStyle: TextStyle(),
      brightness: Brightness.light,
      elevation: 10.0,
    ),
  );

  static final ThemeData gnomeTheme = ThemeData(
    primaryColor: Colors.grey.shade800,
    accentColor: Colors.blue.shade800,
    cardColor: Colors.grey.shade700,
    canvasColor: Colors.grey.shade600,
    brightness: Brightness.dark,
    fontFamily: 'vazir',
    secondaryHeaderColor: Colors.blueGrey.shade200,
    chipTheme: ChipThemeData(
        selectedColor: Colors.black,
        secondarySelectedColor: Colors.black,
        backgroundColor: Colors.blue.shade800,
        disabledColor: Colors.grey,
        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(4.0),
        shape: StadiumBorder(),
        labelStyle: TextStyle(),
        secondaryLabelStyle: TextStyle(),
        brightness: Brightness.light,
        elevation: 10.0),
    // textTheme: TextTheme(
    //   headline: TextStyle(
    //       fontSize: 72.0,
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white),
    //   title: TextStyle(
    //       fontSize: 36.0,
    //       fontStyle: FontStyle.italic,
    //       color: Colors.white),
    //   subtitle: TextStyle(fontSize: 24.0, color: Colors.white),
    //   body2: TextStyle(fontSize: 18.0, color: Colors.white),
    //   body1: TextStyle(fontSize: 14.0, color: Colors.white),
    // ),
    buttonColor: Colors.blue.shade800,
//    buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent)
  );

  static final ThemeData blueTheme = ThemeData(
    fontFamily: 'vazir',
    primaryColor: Colors.blue,
    accentColor: Colors.blue.shade800,
    cardColor: Colors.blue.shade300,
    brightness: Brightness.light,
    canvasColor: Colors.blue.shade100,
    chipTheme: ChipThemeData(
        selectedColor: Colors.amber,
        secondarySelectedColor: Colors.amber,
        backgroundColor: Colors.blue.shade800,
        disabledColor: Colors.grey,
        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(4.0),
        shape: StadiumBorder(),
        labelStyle: TextStyle(),
        secondaryLabelStyle: TextStyle(),
        brightness: Brightness.light,
        elevation: 10.0),
    // textTheme: TextTheme(
    //   headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    //   title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    //   body1: TextStyle(
    //     fontSize: 14.0,
    //   ),
    // ),
    buttonColor: Colors.blue.shade800,
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: Colors.green,
    accentColor: Colors.green.shade800,
    cardColor: Colors.green.shade300,
    brightness: Brightness.light,
    canvasColor: Colors.green.shade100,
    chipTheme: ChipThemeData(
        selectedColor: Colors.red,
        secondarySelectedColor: Colors.red,
        backgroundColor: Colors.green.shade800,
        disabledColor: Colors.grey,
        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(4.0),
        shape: StadiumBorder(),
        labelStyle: TextStyle(),
        secondaryLabelStyle: TextStyle(),
        brightness: Brightness.light,
        elevation: 10.0),
    fontFamily: 'vazir',
    // textTheme: TextTheme(
    //   headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    //   title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    //   caption: TextStyle(fontSize: 28.0),
    //   subtitle: TextStyle(fontSize: 24.0),
    //   body2: TextStyle(fontSize: 18.0),
    //   body1: TextStyle(fontSize: 14.0),
    // ),
    buttonColor: Colors.green.shade800,
    buttonTheme:
        ButtonThemeData(buttonColor: Colors.red, disabledColor: Colors.yellow),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.GREEN:
        return greenTheme;
      case MyThemeKeys.BLUE:
        return blueTheme;
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.GNOME:
        return gnomeTheme;
      default:
        return lightTheme;
    }
  }
}
