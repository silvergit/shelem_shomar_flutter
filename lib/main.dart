import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/themes.dart';
import 'package:shelem_shomar/pages/manage_players.dart';

import './pages/add_person.dart';
import './pages/games_list.dart';
import './pages/home.dart';
import './pages/new_game.dart';
import './pages/top_players.dart';
import 'helpers/custom_theme.dart';

//
//Theme
//

void main() {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Only Portrate orientaition
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]); //

    if (this.locale == null) {
      this.locale = Locale('fa');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: this.locale,
      // switch between en and ru to see effect
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,

//      home: HomePage(),
      theme: CustomTheme.of(context),
//      theme: ThemeData(
//        fontFamily: 'vazir',
//      ),
//      home: Directionality( // add this
//        textDirection: TextDirection.rtl, // set this property
//        child: HomePage(),
//      ),
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/newGame': (BuildContext context) => NewGamePage(),
        '/gamesList': (BuildContext context) => GamesList(),
        '/topPlayers': (BuildContext context) => TopPlayers(),
        '/addPerson': (BuildContext context) => AddPerson(),
        '/managePlayers': (BuildContext context) => ManagePlayers(),
      },
//      onGenerateRoute: (RouteSettings settings) {},
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) => HomePage());
      },
    );
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    return Locale(
        prefs.getString('language_code'), prefs.getString('country_code'));
  }
}
