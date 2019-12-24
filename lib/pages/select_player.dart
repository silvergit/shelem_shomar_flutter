import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';
import 'package:shelem_shomar/models/constants.dart';
import 'package:shelem_shomar/models/player_table.dart';

class SelectPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectPlayerState();
  }
}

class _SelectPlayerState extends State<SelectPlayer> {
  final db = DBHelper();
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildSearchBar() {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: Constants.PADDING, horizontal: Constants.PADDING * 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              icon: Icon(Icons.search), hintText: S.of(context).search),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectPlayer),
      ),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          Expanded(
            child: FutureBuilder(
                future: db.getPlayers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  var data = snapshot.data;
                  return snapshot.hasData
                      ? _buildListView(data)
                      ////////
                      : _buildEmptyArea();
                }),
          ),
        ],
      ),
      drawer: SideDrawer(),
      floatingActionButton: _buildAddButton(context),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/addPerson');
      },
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  Widget _buildListView(List<PlayerTable> data) {
    return ListView.builder(
      itemCount: data.length == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int i) {
        PlayerTable p = data[i];
        return filter == null || filter == ''
            ? _buildListBody(p)
            : p.name.contains(filter) ? _buildListBody(p) : Container();
      },
    );
  }

  Widget _buildListBody(PlayerTable player) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pop(player);
          },
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              player.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          leading: CustomCircleAvatar(
            player.avatar,
            radius: 25.0,
            iconSize: 30.0,
            circleColor: Theme.of(context).accentColor,
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildEmptyArea() {
    return Center(
      child: Text(
        S.of(context).addPlayer,
        style: TextStyle(fontSize: 26.0),
      ),
    );
  }
}
