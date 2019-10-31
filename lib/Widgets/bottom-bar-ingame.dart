import 'package:flutter/material.dart';

class BottomBarInGame extends StatelessWidget {
  Widget bottonWidget;

  BottomBarInGame(this.bottonWidget);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: bottonWidget,
      ),
    );
  }
}
