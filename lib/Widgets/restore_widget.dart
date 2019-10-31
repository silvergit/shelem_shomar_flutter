import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shelem_shomar/generated/i18n.dart';
import 'package:shelem_shomar/helpers/filesize.dart';

class RestoreWidget extends StatefulWidget {
  @override
  _RestoreWidgetState createState() => _RestoreWidgetState();
}

class _RestoreWidgetState extends State<RestoreWidget> {
  List<String> backupFiles = [];

  @override
  void initState() {
    super.initState();
    _getDirectoryFiles();
  }

  _getBackupDirectory() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  _getDirectoryFiles() async {
    List<String> files = [];
    Directory dir = await _getBackupDirectory();
    Directory backupDir = Directory(dir.path + '/db_backup');

    List contents = backupDir.listSync();
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        files.add(fileOrDir.path);
      }
    }

    setState(() {
      backupFiles = files.reversed.toList();
    });
  }

  _copyDataBaseToBackupFolder(BuildContext context, String backupPath) async {
    String dbName = 'shelem_init_db.db';
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'database/', dbName);

    File dbFileBackup = File(backupPath);

    bool exists = await Directory(dir.path + 'database').exists();

    if (!exists) {
      new Directory(dir.path + '/database/').create(recursive: true)
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
    if (await dbFileBackup.exists()) {
      final File restoreFile = await dbFileBackup.copy(dbPath);

      if (await restoreFile.exists()) {
        showSnackBar(context, S.of(context).databaseFileRestoredSuccessfully);
      } else {
        showSnackBar(context, S.of(context).failedToRestoreBackupFile);
      }
    } else {
      showSnackBar(context, S.of(context).databaseFileIsNotExist);
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String _getBackupFileSize(String path) {
    var _file = File(path);
    int _fileSize = _file.lengthSync();
    String readableSize = fileSize(_fileSize);
    return readableSize;
  }

  String _getBackupLastModified(String path) {
    var _file = File(path);
    DateTime _fileDate = _file.lastModifiedSync();
    String date = _fileDate.year.toString() +
        '/' +
        _fileDate.month.toString() +
        '/' +
        _fileDate.day.toString();
    return date;
  }

  _shareBackupFile(String backupFile) async {
    File testFile = new File(backupFile);
    if (!await testFile.exists()) {
      await testFile.create(recursive: true);
      testFile.writeAsStringSync("test for share documents file");
    }
    ShareExtend.share(testFile.path, "file");
  }

  _deleteBackupFile(BuildContext context, int index) async {
    File dbFile = File(backupFiles[index]);

    if (await dbFile.exists()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(S.of(context).doYouWantToDeleteBackupFile + '?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    dbFile.delete();
                    showSnackBar(
                        context, S.of(context).databaseDeletedSuccessfully);

                    setState(() {
                      backupFiles.removeAt(index);
                    });
                  },
                  child: Text(S.of(context).ok)),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(S.of(context).cancel)),
            ],
          );
        },
      );
    } else {
      showSnackBar(context, S.of(context).failedToDeleteDatabaseFile);
    }
  }

  _selectBackUpFromInternalMemory(BuildContext context) async {
    String filePath;

    // Will filter and only let you pick files with svg extension
    filePath = await FilePicker.getFilePath(type: FileType.ANY);

    String fileExt = filePath.split('.').last;

    print(filePath);
    print(fileExt);

    if (fileExt != 'db') {
      showSnackBar(context, S.of(context).theSelectedFileTypeIsWrong);
      return;
    } else {
      _copyDataBaseToBackupFolder(context, filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  S.of(context).pleaseSelectBackupToRestoreIt,
                  style: Theme.of(context).textTheme.body2,
                ),
                Text(S
                    .of(context)
                    .afterRestoringAllPreviousDataFromTheProgramWillBeReplaced),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        backupFiles.length == 0
            ? Expanded(
                child: Center(
                child: Center(
                  child: Text(
                    S.of(context).thereIsNoBackupFileHere,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ),
              ))
            : Expanded(
                child: ListView.builder(
                  itemCount: backupFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(basename(backupFiles[index])),
                          subtitle: Column(
                            children: <Widget>[
                              Text(S.of(context).size +
                                  ': ' +
                                  _getBackupFileSize(backupFiles[index])),
                              Text(S.of(context).created +
                                  ': ' +
                                  _getBackupLastModified(backupFiles[index])),
                            ],
                          ),
                          trailing: Container(
                            width: 100.0,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    _shareBackupFile(backupFiles[index]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteBackupFile(context, index);
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: () => _copyDataBaseToBackupFolder(
                              context, backupFiles[index]),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
        SizedBox(
          height: 20.0,
        ),
        Card(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  S.of(context).orSelectFromPhoneMemory,
                  style: Theme.of(context).textTheme.body2,
                ),
                OutlineButton(
                  child: Text(S.of(context).selectBackupFile),
                  onPressed: () => _selectBackUpFromInternalMemory(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
