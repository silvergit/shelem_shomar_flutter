class PointsTable {
  static const String TABLE_NAME = "points_table";

  static const String ID = "id";
  static const String GAME_ID = "game_id";
  static const String TEAM1POINTS = "team1_oints";
  static const String TEAM2POINTS = "team2_points";
  static const String READ_POINTS = "read_points";
  static const String STARTER = 'starter';
  static const String WHICH_COLOR = 'which_color';
  static const String CREATE_TABLE = "CREATE TABLE " +
      TABLE_NAME +
      "(" +
      ID +
      " INTEGER PRIMARY KEY AUTOINCREMENT," +
      GAME_ID +
      " INTEGER NOT NULL," +
      TEAM1POINTS +
      " TEXT NOT NULL," +
      TEAM2POINTS +
      " TEXT NOT NULL," +
      READ_POINTS +
      " TEXT NOT NULL," +
      STARTER +
      " INTEGER NOT NULL," +
      WHICH_COLOR +
      " TEXT NOT NULL" +
      ")";

  int id;
  int gameId;
  String team1Points;
  String team2Points;
  String readPoints;
  int starter;
  String whichColor;

  PointsTable();

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[GAME_ID] = gameId;
    map[TEAM1POINTS] = team1Points;
    map[TEAM2POINTS] = team2Points;
    map[READ_POINTS] = readPoints;
    map[STARTER] = starter;
    map[WHICH_COLOR] = whichColor;

    if (id != null) {
      map[ID] = id;
    }

    return map;
  }

  PointsTable.fromMap(Map<String, dynamic> map) {
    id = map[ID];
    gameId = map[GAME_ID];
    team1Points = map[TEAM1POINTS];
    team2Points = map[TEAM2POINTS];
    readPoints = map[READ_POINTS];
    starter = map[STARTER];
    whichColor = map[WHICH_COLOR];
  }
}
