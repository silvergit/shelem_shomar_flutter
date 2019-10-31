class PlayerTable {
  static const String TABLE_NAME = "player_table";

// database table and column names
  static const String PLAYER_ID = "player_id";
  static const String PLAYER_NAME = "player_name";
  static const String PLAYER_AVATAR = "player_avatar";

// Query for create table players
  static const String CREATE_TABLE = "CREATE TABLE " +
      TABLE_NAME +
      "(" +
      PLAYER_ID +
      " INTEGER PRIMARY KEY AUTOINCREMENT," +
      PLAYER_NAME +
      " TEXT UNIQUE," +
      PLAYER_AVATAR +
      " TEXT" +
      ")";

  int id;
  String name;
  String avatar;

  PlayerTable();

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[PLAYER_NAME] = name;
    map[PLAYER_AVATAR] = avatar;

    if (id != null) {
      map[PLAYER_ID] = id;
    }

    return map;
  }

  PlayerTable.fromMap(Map<String, dynamic> map) {
    id = map[PLAYER_ID];
    name = map[PLAYER_NAME];
    avatar = map[PLAYER_AVATAR];
  }
}
