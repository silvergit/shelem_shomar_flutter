import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/custom_circle_avatar.dart';
import 'package:shelem_shomar/Widgets/scale_anim_widget.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';
import 'package:shelem_shomar/models/player_table.dart';
import 'package:shelem_shomar/pages/edit_person.dart';

class ManagePlayersListView extends StatefulWidget {
  final List<PlayerTable> players;

  ManagePlayersListView(this.players);

  @override
  _ManagePlayersListViewState createState() => _ManagePlayersListViewState();
}

class _ManagePlayersListViewState extends State<ManagePlayersListView>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  String editText;

  @override
  initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));

    _animationController.forward();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _deletePlayer(int index) async {
    var db = DBHelper();
    int id = widget.players[index].id;
    bool canDelete = false;

    try {
      canDelete = await db.canDeletePlayer(id);
      if (canDelete) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(S
                    .of(context)
                    .areYouWantToDelete(widget.players[index].name)),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            PlayerTable player = await db.getPlayer(id: id);
                            db.deletePlayer(player);
                            setState(() {
                              widget.players.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                          child: Text(S.of(context).ok)),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(S.of(context).cancel)),
                    ],
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(S.of(context).cannotRemoveThePlayerWhoPlayedGame),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(S.of(context).dismiss)),
                ],
              );
            });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Widget _buildListBody(int index) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          leading: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomCircleAvatar(
              widget.players[index].avatar,
              iconSize: 30,
              radius: 25,
              circleColor: Theme.of(context).accentColor,
            ),
          ),
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.players[index].name,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          trailing: Container(
            width: 100.0,
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditPerson(widget.players[index])))),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _deletePlayer(index)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: widget.players.length,
          itemBuilder: (BuildContext context, int index) {
            return Transform(
              transform:
              Matrix4.translationValues(0.0, _animation.value * width, 0.0),
              child: Column(
                children: <Widget>[
                  ScaleAnimWidget(_buildListBody(index)),
                  Divider(
                    color: Theme
                        .of(context)
                        .accentColor,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
