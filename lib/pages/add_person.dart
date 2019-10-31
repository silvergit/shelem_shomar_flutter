import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/dbhelper.dart';

import '../models/player_table.dart';
import '../pages/select_player.dart';

class AddPerson extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPersonState();
  }
}

class _AddPersonState extends State<AddPerson> {
  String _name;
  String _avatar;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void addPlayer() {
    var db = DBHelper();
    var player = PlayerTable();
    player.name = _name;
    player.avatar = _avatar;
    db.addPlayer(player);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Builder(
        builder: (BuildContext context) {
          return new Stack(
            children: <Widget>[
              _buildBackground(context),
              new Container(
                padding: EdgeInsets.only(
                  top: 56,
                  bottom: 16,
                  left: 16,
                  right: 16,
                ),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5,
                    left: 20.0,
                    right: 20.0),
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 50.0),
                        child: _buildTextFormField(context),
                      ),
                    ),
                    new Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildOkButton(context),
                          SizedBox(
                            width: 20.0,
                          ),
                          _buildCancelButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 5 - 50,
                left: 16,
                right: 16,
//                child:  _buildCircleAvatar(context),
                child: _buildCircleAvatar(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    _saveImage(image);
  }

  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    _saveImage(image);
  }

  void _saveImage(File image) async {
    // Step 3: Get directory where we can duplicate selected file.
    Directory dir = await getApplicationDocumentsDirectory();
    String fileName = basename(image.path);
    final String path =
        dir.path + '/' + DateTime.now().toString() + '_' + fileName;

    // Step 4: Copy the file to a application document directory.
    final File localImage = await image.copy('$path');

    setState(() {
      _avatar = localImage.path;
    });
  }

  void _addPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _getImageFromGallery();
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.photo,
                          size: 78.0,
                        ),
                        Text(S.of(context).gallery),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _getImageFromCamera();
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.camera,
                          size: 78.0,
                        ),
                        Text(S.of(context).camera),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackground(BuildContext context) {
    return new Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _buildOkButton(BuildContext context) {
    return new RaisedButton(
      onPressed: () {
        _submit(context);
      },
      color: Theme.of(context).primaryColor,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: new Text(S.of(context).add,
          style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    addPlayer();

    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SelectPlayer()));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Widget _buildCancelButton(BuildContext context) {
    return new RaisedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      color: Theme.of(context).primaryColor,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      child: new Text(S.of(context).cancel,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buildTextFormField(BuildContext context) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) return S.of(context).nameIsRequired;
        return null;
      },
      decoration: InputDecoration(
        labelText: S.of(context).playerName,
      ),
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildCircleAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _addPhoto(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 60,
            child: _avatar == null
                ? IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: null,
                    iconSize: 68.0,
                    color: Colors.white,
                  )
                : Container(
                    width: 110.0,
                    height: 110.0,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                        image: FileImage(File(_avatar)),
                      ),
                    )),
          ),
          Positioned(
            bottom: -10.0,
            child: Container(
              margin: EdgeInsets.only(left: 110.0),
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: _avatar == null
                      ? Theme.of(context).cardColor
                      : Theme.of(context).accentColor,
                ),
                onPressed: () {
                  setState(() {
                    _avatar = null;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
