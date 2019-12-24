import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/game_table.dart';
import '../models/player_table.dart';
import '../models/points_table.dart';
import '../models/win_loss_table.dart';

class DBHelper {
  static const dbName = 'shelem_init_db.db';
  static final DBHelper _instance = new DBHelper.internal();

  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'database', dbName);

    var dB = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(PlayerTable.CREATE_TABLE);
    await db.execute(GameTable.CREATE_TABLE);
    await db.execute(PointsTable.CREATE_TABLE);
    await db.execute(WinLossTable.CREATE_TABLE);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS ${PlayerTable.TABLE_NAME}");
    await db.execute("DROP TABLE IF EXISTS ${PointsTable.TABLE_NAME}");
    await db.execute("DROP TABLE IF EXISTS ${WinLossTable.TABLE_NAME}");
    await db.execute("DROP TABLE IF EXISTS ${GameTable.TABLE_NAME}");

    _onCreate(db, newVersion);
  }

//INSERT
  Future<int> addPlayer(PlayerTable player) async {
    var dbClient = await db;
    int res = await dbClient.insert(PlayerTable.TABLE_NAME, player.toMap());
    return res;
  }

  Future<int> addWinLossState(WinLossTable winLoss) async {
    var dbClient = await db;
    int res = await dbClient.insert(WinLossTable.TABLE_NAME, winLoss.toMap());
    return res;
  }

  Future<int> addGame(GameTable game) async {
    var dbClient = await db;
    int res = await dbClient.insert(GameTable.TABLE_NAME, game.toMap());
    return res;
  }

  Future<int> addPoints(PointsTable points) async {
    var dbClient = await db;
    int res = await dbClient.insert(PointsTable.TABLE_NAME, points.toMap());
    return res;
  }

  //GET
  Future<PlayerTable> getPlayer({int id, String name}) async {
    var dbClient = await db;
    List<Map> players;

    if (id != null && name == null) {
      players = await dbClient.query(PlayerTable.TABLE_NAME,
          where: PlayerTable.PLAYER_ID + '=?', whereArgs: [id]);
    } else if (id == null && name != null) {
      players = await dbClient.query(PlayerTable.TABLE_NAME,
          where: PlayerTable.PLAYER_NAME + '=?', whereArgs: [name]);
    }

    if (players.length > 0) {
      return new PlayerTable.fromMap(players.first);
    }
    return null;
  }

  //GET ALL
  Future<List<PlayerTable>> getPlayers() async {
    var dbClient = await db;
    List<Map> list = await dbClient.query(PlayerTable.TABLE_NAME,
        orderBy: PlayerTable.PLAYER_NAME);
    List<PlayerTable> players = new List();

    for (var node in list) {
      var player = new PlayerTable();
      player.name = node[PlayerTable.PLAYER_NAME];
      player.avatar = node[PlayerTable.PLAYER_AVATAR];
      player.id = node[PlayerTable.PLAYER_ID];
      players.add(player);
    }

    return players;
  }

  Future<List<GameTable>> getAllGames() async {
    var dbClient = await db;
    List<Map> list = await dbClient.query(GameTable.TABLE_NAME,
        orderBy: GameTable.DATE + " DESC");
    List<GameTable> games = new List();

    for (var node in list) {
      var game = new GameTable();
      game.player1Id = node[GameTable.PLAYER1_ID];
      game.player2Id = node[GameTable.PLAYER2_ID];
      game.player3Id = node[GameTable.PLAYER3_ID];
      game.player4Id = node[GameTable.PLAYER4_ID];
      game.date = node[GameTable.DATE];
      game.time = node[GameTable.TIME];
      game.team1Points = node[GameTable.TEAM1_POINTS];
      game.team2Points = node[GameTable.TEAM2_POINTS];
      game.gameType = node[GameTable.GAME_TYPE];
      game.id = node[GameTable.GAME_ID];
      games.add(game);
    }

    return games;
  }

  Future<List<WinLossTable>> getWinLooses() async {
    var dbClient = await db;
    List<Map> list = await dbClient.query(WinLossTable.TABLE_NAME);
    List<WinLossTable> states = new List();

    for (var node in list) {
      var state = new WinLossTable();
      state.gameId = node[WinLossTable.GAME_ID];
      state.playerId = node[WinLossTable.PLAYER_ID];
      state.state = node[WinLossTable.STATE];
      state.id = node[WinLossTable.ID];
      states.add(state);
    }

    return states;
  }

  Future<List<PointsTable>> getPoints(int gameId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.query(PointsTable.TABLE_NAME,
        where: PointsTable.GAME_ID + "=?", whereArgs: [gameId]);
    List<PointsTable> points = new List();

    for (var node in list) {
      var point = new PointsTable();
      point.id = node[PointsTable.ID];
      point.gameId = node[PointsTable.GAME_ID];
      point.team1Points = node[PointsTable.TEAM1POINTS];
      point.team2Points = node[PointsTable.TEAM2POINTS];
      point.readPoints = node[PointsTable.READ_POINTS];
      point.starter = node[PointsTable.STARTER];
      point.whichColor = node[PointsTable.WHICH_COLOR];
      points.add(point);
    }

    return points;
  }

  //UPDATE
  Future<bool> updatePlayer(PlayerTable player) async {
    var dbClient = await db;
    var res = await dbClient.update(PlayerTable.TABLE_NAME, player.toMap(),
        where: PlayerTable.PLAYER_ID + "=?", whereArgs: <int>[player.id]);
    return res > 0 ? true : false;
  }

  //DELETE
  Future<int> deletePlayer(PlayerTable player) async {
    var dbClient = await db;
    var res = await dbClient.delete(PlayerTable.TABLE_NAME,
        where: PlayerTable.PLAYER_ID + "=?", whereArgs: [player.id]);
    return res;
  }

  //QUERY
  Future<bool> canDeletePlayer(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.query(GameTable.TABLE_NAME);

    for (var node in list) {
      if (id == node[GameTable.PLAYER1_ID] ||
          id == node[GameTable.PLAYER2_ID] ||
          id == node[GameTable.PLAYER3_ID] ||
          id == node[GameTable.PLAYER4_ID]) {
        return false;
      }
    }
    return true;
  }
}
