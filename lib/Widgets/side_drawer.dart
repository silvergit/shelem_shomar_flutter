import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/custom_theme.dart';
import 'package:shelem_shomar/helpers/themes.dart';
import 'package:shelem_shomar/main.dart';
import 'package:shelem_shomar/pages/about_page.dart';
import 'package:shelem_shomar/pages/backup_restore.dart';
import 'package:shelem_shomar/pages/help_page.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideDrawerState();
  }
}

class _SideDrawerState extends State<SideDrawer> {
  String _projectVersion = '';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  _getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  Future _changeTheme(BuildContext buildContext, MyThemeKeys key) async {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', key.toString());
  }

  Widget _buildThemeTiles(Color color1, Color color2, MyThemeKeys key) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(width: 1.0, color: Theme.of(context).accentColor)),
        width: 50,
        height: 50,
        child: Column(
          children: <Widget>[
            Container(
              height: 24,
              color: color1,
            ),
            Container(
              height: 24,
              color: color2,
            ),
          ],
        ),
      ),
      onTap: () {
        _changeTheme(context, key);
        Navigator.of(context).pop();
      },
    );
  }

  Widget _headerPart() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
      color: Theme.of(context).accentColor,
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/icon.png',
            width: 150.0,
            height: 150.0,
            color: null,
          ),
          Center(
            child: Text(
              S.of(context).shelemShomar,
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              '${S.of(context).version}: $_projectVersion',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themePart() {
    return ExpansionTile(
      leading: Icon(Icons.palette),
      title: Text(S.of(context).theme),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildThemeTiles(Colors.grey.shade800, Colors.blue.shade700,
                  MyThemeKeys.GNOME),
              _buildThemeTiles(
                  Colors.green, Colors.green.shade200, MyThemeKeys.GREEN),
              _buildThemeTiles(
                  Colors.blue, Colors.blue.shade200, MyThemeKeys.BLUE),
              _buildThemeTiles(Colors.blue, Colors.white, MyThemeKeys.LIGHT),
            ],
          ),
        )
      ],
    );
  }

  Widget _languagePart() {
    return ExpansionTile(
        leading: Icon(Icons.language),
        title: Text('Language'),
        children: <Widget>[
          _chooseLanguage('English', 'en'),
          _chooseLanguage('فارسی', 'fa'),
        ]);
  }

  Widget _chooseLanguage(String languageName, String languageCode,
      {String countryCode = ''}) {
    return ListTile(
      title: Text(languageName),
      onTap: () async {
        // If the chosen language is not English
        // Then, let's change it to English
        if (_getLanguageCode(context) != languageCode) {
          // step one, save the chosen locale
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('languageCode', languageCode);
          await prefs.setString('countryCode', countryCode);

          // step two, rebuild the whole app, with the new locale
          MyApp.setLocale(context, Locale(languageCode, countryCode));
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _backupRestorePart() {
    return ExpansionTile(
      title: Text(S.of(context).backupRestore),
      leading: Icon(Icons.backup),
      children: <Widget>[
        ListTile(
          title: Text(S.of(context).backup),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => BackupRestore(0)));
          },
        ),
        ListTile(
          title: Text(S.of(context).restore),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => BackupRestore(1)));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            _headerPart(),
            _themePart(),
            _languagePart(),
            _backupRestorePart(),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(S.of(context).help),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HelpPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text(S.of(context).about),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AboutPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
