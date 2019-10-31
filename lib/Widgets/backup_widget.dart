import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelem_shomar/generated/i18n.dart';

class BackupWidget extends StatefulWidget {
  @override
  _BackupWidgetState createState() => _BackupWidgetState();
}

class _BackupWidgetState extends State<BackupWidget> {
  _deleteSharedPreferences(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  copyDataBaseToBackupFolder(BuildContext context) async {
    String backUpName = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString() +
        '_' +
        DateTime.now().hour.toString() +
        '-' +
        DateTime.now().minute.toString() +
        '-' +
        DateTime.now().second.toString() +
        '_backup.db';
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'database/shelem_init_db.db');
    String backupPath = join(dir.path, 'db_backup/', backUpName);
    File dbFile = File(dbPath);

    if (!await Directory(dir.path + '/db_backup/').exists()) {
      Directory(dir.path + '/db_backup/').create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }

    if (await dbFile.exists()) {
      final File backupFile = await dbFile.copy(backupPath);

      if (await backupFile.exists()) {
        showSnackBar(context, S.of(context).backupFileCreatedSuccessfully);
      } else {
        showSnackBar(context, S.of(context).failedToCreateBackupFile);
      }
    } else {
      showSnackBar(context, S.of(context).databaseFileIsNotExist);
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future _restoreDatabase(BuildContext appContext) async {
    showDialog(
        context: appContext,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text(S.of(context).ok),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteDatabase(appContext);
                  _deleteSharedPreferences(context);
                },
              ),
              FlatButton(
                child: Text(S.of(context).cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
            content: Text(S.of(context).doYouWantToDeleteAppData + '?'),
          );
        });
  }

  _deleteDatabase(BuildContext context) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'database/shelem_init_db.db');

    File dbFile = File(dbPath);

    if (await dbFile.exists()) {
      dbFile.delete();
      showSnackBar(context, S.of(context).databaseDeletedSuccessfully);
    } else {
      showSnackBar(context, S.of(context).failedToDeleteDatabaseFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  S.of(context).backupAllDataToMemory,
                  style: Theme.of(context).textTheme.body2,
                ),
                Text(S.of(context).youCanExportBackupsToAnotherPhoneAndUseIt),
                SizedBox(
                  height: 15.0,
                ),
                OutlineButton(
                  child: Text(S.of(context).backupNow),
                  onPressed: () {
                    copyDataBaseToBackupFolder(context);
                  },
                )
              ],
            ),
          ),
        ),
        Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  S.of(context).resetDataBase,
                  style: Theme.of(context).textTheme.body2,
                ),
                Text(S.of(context).resetDataBaseMessageInfo),
                OutlineButton(
                  onPressed: () => _restoreDatabase(context),
                  child: Text(S.of(context).resetDataBase),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
