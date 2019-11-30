// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'messages_all.dart';

class S {

  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null
        ? locale.languageCode
        : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }

  String get UseCommand {
    return Intl.message(
        "flutter pub run gen_lang:generate", name: 'UseCommand');
  }

  String get shelemShomar {
    return Intl.message("Shelem Shomar", name: 'shelemShomar');
  }

  String get newGame {
    return Intl.message("New Game", name: 'newGame');
  }

  String get managePlayers {
    return Intl.message("Manage Players", name: 'managePlayers');
  }

  String get topPlayers {
    return Intl.message("Top Players", name: 'topPlayers');
  }

  String get gamesList {
    return Intl.message("Games List", name: 'gamesList');
  }

  String get couldNotLaunch {
    return Intl.message("Could not launch", name: 'couldNotLaunch');
  }

  String get aboutShelemShomar {
    return Intl.message("About Shelem shomar", name: 'aboutShelemShomar');
  }

  String get version {
    return Intl.message("Version", name: 'version');
  }

  String get morfaceSoft {
    return Intl.message("Morface Soft ™", name: 'morfaceSoft');
  }

  String get aCounterAppForShelemGame {
    return Intl.message(
        "A counter app for Shelem game.", name: 'aCounterAppForShelemGame');
  }

  String get developer {
    return Intl.message("Developer", name: 'developer');
  }

  String get alirezaPazhouhesh {
    return Intl.message("Alireza Pazhouhesh", name: 'alirezaPazhouhesh');
  }

  String get contactUs {
    return Intl.message("Contact us", name: 'contactUs');
  }

  String get gallery {
    return Intl.message("Gallery", name: 'gallery');
  }

  String get camera {
    return Intl.message("Camera", name: 'camera');
  }

  String get add {
    return Intl.message("Add", name: 'add');
  }

  String get cancel {
    return Intl.message("Cancel", name: 'cancel');
  }

  String get nameIsRequired {
    return Intl.message("Name is required", name: 'nameIsRequired');
  }

  String get playerName {
    return Intl.message("Player name", name: 'playerName');
  }

  String get editPlayer {
    return Intl.message("Edit player", name: 'editPlayer');
  }

  String get games {
    return Intl.message("Games", name: 'games');
  }

  String get wins {
    return Intl.message("Wins", name: 'wins');
  }

  String get looses {
    return Intl.message("Looses", name: 'looses');
  }

  String get score {
    return Intl.message("score", name: 'score');
  }

  String get thereIsNoGameHere {
    return Intl.message("There is no game here", name: 'thereIsNoGameHere');
  }

  String get help {
    return Intl.message("Help", name: 'help');
  }

  String get opening {
    return Intl.message("Opening", name: 'opening');
  }

  String get gameOver {
    return Intl.message("Game over", name: 'gameOver');
  }

  String get backToGame {
    return Intl.message("Back to game", name: 'backToGame');
  }

  String get quitAndSaveGame {
    return Intl.message("Quit & save game", name: 'quitAndSaveGame');
  }

  String get finalPoints {
    return Intl.message("Final points", name: 'finalPoints');
  }

  String get openHand {
    return Intl.message("Open hand", name: 'openHand');
  }

  String get closeHand {
    return Intl.message("Close hand", name: 'closeHand');
  }

  String get readPoints {
    return Intl.message("Read points", name: 'readPoints');
  }

  String get getPoints {
    return Intl.message("Get points", name: 'getPoints');
  }

  String get getPointsNotCalculateAfter1100 {
    return Intl.message("Get points not calculate after 1100",
        name: 'getPointsNotCalculateAfter1100');
  }

  String get gameChart {
    return Intl.message("Game chart", name: 'gameChart');
  }

  String get addPlayerFirst {
    return Intl.message("Add player first", name: 'addPlayerFirst');
  }

  String get firstTeamPlayers {
    return Intl.message("First team players", name: 'firstTeamPlayers');
  }

  String get secondTeamPlayers {
    return Intl.message("Second team players", name: 'secondTeamPlayers');
  }

  String get initPointsOptional {
    return Intl.message("Init points (Optional)", name: 'initPointsOptional');
  }

  String get firstTeamPoints {
    return Intl.message("First team points", name: 'firstTeamPoints');
  }

  String get secondTeamPoints {
    return Intl.message("Second team points", name: 'secondTeamPoints');
  }

  String get gameType {
    return Intl.message("Game type", name: 'gameType');
  }

  String get doubleOptions {
    return Intl.message("Double options", name: 'doubleOptions');
  }

  String get doublePos {
    return Intl.message("Double Pos", name: 'doublePos');
  }

  String get doubleNeg {
    return Intl.message("Double Neg", name: 'doubleNeg');
  }

  String get first {
    return Intl.message("First", name: 'first');
  }

  String get second {
    return Intl.message("Second", name: 'second');
  }

  String get selectAllPlayerNames {
    return Intl.message(
        "Select all player names", name: 'selectAllPlayerNames');
  }

  String get ok {
    return Intl.message("Ok", name: 'ok');
  }

  String get start {
    return Intl.message("Start", name: 'start');
  }

  String get playAGameFirst {
    return Intl.message("Play a game first.", name: 'playAGameFirst');
  }

  String get loadingData {
    return Intl.message("Loading data", name: 'loadingData');
  }

  String get error {
    return Intl.message("Error", name: 'error');
  }

  String get selectPlayer {
    return Intl.message("Select player", name: 'selectPlayer');
  }

  String get addPlayer {
    return Intl.message("Add player", name: 'addPlayer');
  }

  String get addPlayersAndPlayGamesFirst {
    return Intl.message("Add players and play games first",
        name: 'addPlayersAndPlayGamesFirst');
  }

  String get kons {
    return Intl.message("Kons", name: 'kons');
  }

  String get shelem {
    return Intl.message("Shelem", name: 'shelem');
  }

  String get scores {
    return Intl.message("Scores", name: 'scores');
  }

  String get bestPlayer {
    return Intl.message("Best player", name: 'bestPlayer');
  }

  String get worsePlayer {
    return Intl.message("Worse player", name: 'worsePlayer');
  }

  String get handsPlayed {
    return Intl.message("Hands played", name: 'handsPlayed');
  }

  String get maxReadIs {
    return Intl.message("Max read is", name: 'maxReadIs');
  }

  String get gameFinishedIn {
    return Intl.message("Game finished in", name: 'gameFinishedIn');
  }

  String get doublePositive {
    return Intl.message("Double positive", name: 'doublePositive');
  }

  String get doubleNegative {
    return Intl.message("Double negative", name: 'doubleNegative');
  }

  String get topRead {
    return Intl.message("Top Read", name: 'topRead');
  }

  String get readCount {
    return Intl.message("Read Count", name: 'readCount');
  }

  String get winners {
    return Intl.message("Winners", name: 'winners');
  }

  String get gameDetails {
    return Intl.message("Game details", name: 'gameDetails');
  }

  String get choose {
    return Intl.message("Choose", name: 'choose');
  }

  String get backup {
    return Intl.message("Backup", name: 'backup');
  }

  String get restore {
    return Intl.message("Restore", name: 'restore');
  }

  String get about {
    return Intl.message("About", name: 'about');
  }

  String get openHandToStart {
    return Intl.message("Open hand to start", name: 'openHandToStart');
  }

  String get refreshPage {
    return Intl.message("Refresh page", name: 'refreshPage');
  }

  String get loading {
    return Intl.message("Loading", name: 'loading');
  }

  String areYouWantToDelete(name) {
    return Intl.message(
        "Are you want to delete ${name}?", name: 'areYouWantToDelete',
        args: [name]);
  }

  String get cannotRemoveThePlayerWhoPlayedGame {
    return Intl.message("Cannot remove the player who played game",
        name: 'cannotRemoveThePlayerWhoPlayedGame');
  }

  String get dismiss {
    return Intl.message("Dismiss", name: 'dismiss');
  }

  String getPointsMustBeSmallerThan(get) {
    return Intl.message("Get points must be smaller than ${get}",
        name: 'getPointsMustBeSmallerThan', args: [get]);
  }

  String get getPointsIsIncorrect {
    return Intl.message(
        "Get points is incorrect", name: 'getPointsIsIncorrect');
  }

  String get readPointsIsIncorrect {
    return Intl.message(
        "Read Points is incorrect", name: 'readPointsIsIncorrect');
  }

  String readPointsMustBeEqualOrSmallerThan(get) {
    return Intl.message("Read Points must be equal or smaller than ${get}",
        name: 'readPointsMustBeEqualOrSmallerThan', args: [get]);
  }

  String get forReadKONSBothTeamPointsMustBeGreaterThen1000 {
    return Intl.message(
        "For read KONS both team points must be greater then 1000",
        name: 'forReadKONSBothTeamPointsMustBeGreaterThen1000');
  }

  String get selectGameType {
    return Intl.message("Select game type", name: 'selectGameType');
  }

  String get newName {
    return Intl.message("New name", name: 'newName');
  }

  String get search {
    return Intl.message("Search", name: 'search');
  }

  String get edit {
    return Intl.message("Edit", name: 'edit');
  }

  String get backupRestore {
    return Intl.message("Backup/Restore", name: 'backupRestore');
  }

  String get backupAllDataToMemory {
    return Intl.message(
        "Backup all data to phone memory", name: 'backupAllDataToMemory');
  }

  String get youCanExportBackupsToAnotherPhoneAndUseIt {
    return Intl.message(
        "You can export backups to another phone and use it in this phone.",
        name: 'youCanExportBackupsToAnotherPhoneAndUseIt');
  }

  String get backupNow {
    return Intl.message("Backup now", name: 'backupNow');
  }

  String get lastBackup {
    return Intl.message("Last backup", name: 'lastBackup');
  }

  String get youCanSeeBackupFilesHere {
    return Intl.message(
        "You can see backup files here", name: 'youCanSeeBackupFilesHere');
  }

  String get pleaseSelectBackupToRestoreIt {
    return Intl.message("Please select backup to restore it",
        name: 'pleaseSelectBackupToRestoreIt');
  }

  String get afterRestoringAllPreviousDataFromTheProgramWillBeReplaced {
    return Intl.message(
        "After restoring, all previous data from the program will be replaced. Make sure to have a backup first.",
        name: 'afterRestoringAllPreviousDataFromTheProgramWillBeReplaced');
  }

  String get resetDataBase {
    return Intl.message("Reset Database", name: 'resetDataBase');
  }

  String get resetDataBaseMessageInfo {
    return Intl.message(
        "Deleting the database will delete all your data. First, make sure you back up your application data.",
        name: 'resetDataBaseMessageInfo');
  }

  String get orSelectFromPhoneMemory {
    return Intl.message(
        "Or select from phone memory", name: 'orSelectFromPhoneMemory');
  }

  String get selectBackupFile {
    return Intl.message("Select Backup File", name: 'selectBackupFile');
  }

  String get thereIsNoBackupFileHere {
    return Intl.message(
        "There is no backup file here", name: 'thereIsNoBackupFileHere');
  }

  String get youChooseSamePlayers {
    return Intl.message(
        "You choose same players", name: 'youChooseSamePlayers');
  }

  String get reloadPageToSeeChanges {
    return Intl.message(
        "Reload page to see changes", name: 'reloadPageToSeeChanges');
  }

  String get failedToRemovePrefMemory {
    return Intl.message(
        "Failed to remove pref memory", name: 'failedToRemovePrefMemory');
  }

  String get theme {
    return Intl.message("Theme", name: 'theme');
  }

  String get clearMemory {
    return Intl.message("Clear memory", name: 'clearMemory');
  }

  String get doYouWantToDeleteAppData {
    return Intl.message(
        "Do you want to delete App data", name: 'doYouWantToDeleteAppData');
  }

  String get databaseFileIsNotExist {
    return Intl.message(
        "Database file is not exist", name: 'databaseFileIsNotExist');
  }

  String get failedToCreateBackupFile {
    return Intl.message(
        "Failed to create backup file", name: 'failedToCreateBackupFile');
  }

  String get backupFileCreatedSuccessfully {
    return Intl.message("Backup file created successfully",
        name: 'backupFileCreatedSuccessfully');
  }

  String get databaseDeletedSuccessfully {
    return Intl.message(
        "Database deleted successfully", name: 'databaseDeletedSuccessfully');
  }

  String get failedToDeleteDatabaseFile {
    return Intl.message(
        "Failed to delete Database file", name: 'failedToDeleteDatabaseFile');
  }

  String get databaseFileRestoredSuccessfully {
    return Intl.message("Database file restored successfully",
        name: 'databaseFileRestoredSuccessfully');
  }

  String get failedToRestoreBackupFile {
    return Intl.message(
        "Failed to restore backup file", name: 'failedToRestoreBackupFile');
  }

  String get doYouWantToDeleteBackupFile {
    return Intl.message("Do you want to delete backup file",
        name: 'doYouWantToDeleteBackupFile');
  }

  String get theSelectedFileTypeIsWrong {
    return Intl.message(
        "The selected file type is wrong. Select a ShelemShomar Database file",
        name: 'theSelectedFileTypeIsWrong');
  }

  String get size {
    return Intl.message("Size", name: 'size');
  }

  String get created {
    return Intl.message("Created", name: 'created');
  }

  String get slm {
    return Intl.message("Slm", name: 'slm');
  }

  String get kns {
    return Intl.message("Kns", name: 'kns');
  }

  String get deleteFormDefaultValues {
    return Intl.message(
        "Delete form default values", name: 'deleteFormDefaultValues');
  }

  String get getPointsAfter1100 {
    return Intl.message("Get points after 1100", name: 'getPointsAfter1100');
  }

  String get write {
    return Intl.message("Write", name: 'write');
  }

  String get doNotWrite {
    return Intl.message("Don`t write", name: 'doNotWrite');
  }

  String get doYouWantToExit {
    return Intl.message("Do you want to exit?", name: 'doYouWantToExit');
  }

  String get areYouSure {
    return Intl.message("Are you sure?", name: 'areYouSure');
  }

  String get yes {
    return Intl.message("Yes", name: 'yes');
  }

  String get no {
    return Intl.message("No", name: 'no');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", ""),
      Locale("fa", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}
