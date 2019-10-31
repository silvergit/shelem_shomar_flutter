class GameTable {
  static const String TABLE_NAME = "game_table";
  static const String GAME_ID = "GameId";
  static const String PLAYER1_ID = "player1_id";
  static const String PLAYER2_ID = "player2_id";
  static const String PLAYER3_ID = "player3_id";
  static const String PLAYER4_ID = "player4_id";
  static const String DATE = "date";
  static const String TIME = "time";
  static const String TEAM1_POINTS = "team1_points";
  static const String TEAM2_POINTS = "team2_points";
  static const String GAME_TYPE = "game_type";

  static const String CREATE_TABLE = "CREATE TABLE " +
      TABLE_NAME +
      "(" +
      GAME_ID +
      " INTEGER PRIMARY KEY AUTOINCREMENT," +
      PLAYER1_ID +
      " INTEGER NOT NULL," +
      PLAYER2_ID +
      " INTEGER NOT NULL," +
      PLAYER3_ID +
      " INTEGER NOT NULL," +
      PLAYER4_ID +
      " INTEGER NOT NULL," +
      DATE +
      " TEXT," +
      TIME +
      " TEXT," +
      TEAM1_POINTS +
      " INTEGER NOT NULL," +
      TEAM2_POINTS +
      " INTEGER NOT NULL," +
      GAME_TYPE +
      " INTEGER" +
      ")";

  int id;
  int player1Id;
  int player2Id;
  int player3Id;
  int player4Id;
  String date;
  String time;
  int team1Points;
  int team2Points;
  int gameType;

  GameTable();

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[PLAYER1_ID] = player1Id;
    map[PLAYER2_ID] = player2Id;
    map[PLAYER3_ID] = player3Id;
    map[PLAYER4_ID] = player4Id;
    map[DATE] = date;
    map[TIME] = time;
    map[TEAM1_POINTS] = team1Points;
    map[TEAM2_POINTS] = team2Points;
    map[GAME_TYPE] = gameType;

    if (id != null) {
      map[GAME_ID] = id;
    }
    return map;
  }

  GameTable.fromMap(Map<String, dynamic> map) {
    id = map[GAME_ID];
    player1Id = map[PLAYER1_ID];
    player2Id = map[PLAYER2_ID];
    player3Id = map[PLAYER3_ID];
    player4Id = map[PLAYER4_ID];
    date = map[DATE];
    time = map[TIME];
    team1Points = map[TEAM1_POINTS];
    team2Points = map[TEAM2_POINTS];
    gameType = map[GAME_TYPE];
  }
}
