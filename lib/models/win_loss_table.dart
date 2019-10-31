class WinLossTable {
  static const String TABLE_NAME = "winlose_table";
  static const String ID = "id";
  static const String GAME_ID = "gameId";
  static const String PLAYER_ID = "playerId";
  static const String STATE = "state";
  static const String CREATE_TABLE = "CREATE TABLE " +
      TABLE_NAME +
      "(" +
      ID +
      " INTEGER PRIMARY KEY AUTOINCREMENT," +
      GAME_ID +
      " INTEGER NOT NULL," +
      PLAYER_ID +
      " INTEGER NOT NULL," +
      STATE +
      " INTEGER" +
      ")";

  int id;
  int gameId;
  int playerId;
  int state; //1 for Win and 0 for Lose
  WinLossTable();

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map[GAME_ID] = gameId;
    map[PLAYER_ID] = playerId;
    map[STATE] = state;

    if (id != null) {
      map[ID] = id;
    }
    return map;
  }

  WinLossTable.fromMap(dynamic map) {
    id = map[ID];
    gameId = map[GAME_ID];
    playerId = map[PLAYER_ID];
    state = map[STATE];
  }
}
