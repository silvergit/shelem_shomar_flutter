import 'package:flutter/material.dart';
import 'package:shelem_shomar/Widgets/backup_widget.dart';
import 'package:shelem_shomar/Widgets/restore_widget.dart';
import 'package:shelem_shomar/Widgets/side_drawer.dart';
import 'package:shelem_shomar/generated/i18n.dart';

class BackupRestore extends StatefulWidget {
  final int initSelect;

  BackupRestore(this.initSelect);

  @override
  State<StatefulWidget> createState() {
    return _BackupRestoreState();
  }
}

class _BackupRestoreState extends State<BackupRestore> {
  int _selectedIndex;
  static List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initSelect;
    _widgetOptions = <Widget>[
      BackupWidget(),
      RestoreWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).backupRestore),
      ),
      drawer: SideDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.backup),
            title: Text('Backup'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restore),
            title: Text('Restore'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
