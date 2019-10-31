import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/my-buttons.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../Widgets/side_drawer.dart';

class HomePage extends StatelessWidget {
  Widget _getSomeSpace(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  _buildCard({Config config, Color backgroundColor = Colors.transparent}) {
    return Container(
      height: 200.0,
      width: double.infinity,
      child: Card(
        elevation: 12.0,
//        margin: EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        child: Stack(
          children: [
            WaveWidget(
              config: config,
              backgroundColor: backgroundColor,
              size: Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ],
        ),
      ),
    );
  }

  final List<MaskFilter> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];

  Widget _buildTopCard(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        _buildCard(
          config: CustomConfig(
            colors: [
              Theme.of(context).canvasColor,
              Theme.of(context).primaryColor,
              Theme.of(context).cardColor,
              Theme.of(context).accentColor,
            ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.20, 0.23, 0.25, 0.30],
            blur: _blurs[4],
          ),
        ),
        Positioned(
          bottom: 5.0,
          left: 10.0,
          child: Image.asset(
            'assets/icon.png',
            width: 200.0,
            height: 200.0,
            color: null,
          ),
        ),
        Positioned(
          bottom: 5.0,
          right: 10.0,
          child: Text(
            S.of(context).shelemShomar,
            style: TextStyle(
              fontSize: 36.0,
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(
      BuildContext context, String text, String routeName, icon) {
    return MyButton(
      text,
      icon,
      () => Navigator.pushNamed(context, routeName),
      fontSize: 24.0,
      height: 60.0,
      margin: 0.0,
      iconBackColor: Theme.of(context).accentColor,
      iconSize: 34.0,
      backColor: Theme.of(context).primaryColor,
      fontColor: Theme.of(context).canvasColor,
      iconColor: Colors.white,
      splashColor: Colors.white,
    );
  }

  Widget _buildGameButtons(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500.0 : deviceWidth * 0.9;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          width: targetWidth,
          child: Column(
            children: <Widget>[
              _buildButtons(context, S.of(context).newGame, '/newGame',
                  Icons.videogame_asset),
              _getSomeSpace(0, 20.0),
              _buildButtons(
                  context, S.of(context).gamesList, '/gamesList', Icons.list),
              _getSomeSpace(0, 20.0),
              _buildButtons(context, S.of(context).managePlayers,
                  '/managePlayers', Icons.person),
              _getSomeSpace(0, 20.0),
              _buildButtons(
                  context, S.of(context).topPlayers, '/topPlayers', Icons.cake),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(S.of(context).shelemShomar),
      ),
      drawer: SideDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTopCard(context),
              _getSomeSpace(0.0, 15.0),
              _buildGameButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}
