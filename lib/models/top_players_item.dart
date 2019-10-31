import 'dart:core';
import 'dart:math';

class TopPlayersItem {
  int mPlayerId;
  int mWins;
  int mLosses;

  TopPlayersItem({this.mPlayerId, this.mWins, this.mLosses});

  static double roundAvoid(double value, int places) {
    double scale = pow(10, places);
    return (value * scale).round() / scale;
  }

  int getPlayerId() {
    return mPlayerId;
  }

  void setPlayerId(int playerId) {
    mPlayerId = playerId;
  }

  double getScore() {
    if (getGames() != 0) {
      double points = ((mWins * 2) + (mLosses * -1)) * getGames() / 10;
      return points;
    } else {
      return 0;
    }
  }

  int getGames() {
    return mWins + mLosses;
  }

  int getWins() {
    return mWins;
  }

  void setWins(int wins) {
    mWins = wins;
  }

  int getLosses() {
    return mLosses;
  }

  void setLosses(int losses) {
    mLosses = losses;
  }
}
