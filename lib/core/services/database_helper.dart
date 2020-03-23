import 'dart:async';
import 'dart:io';
//import 'dart:convert';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/models/user_model.dart';
import '../../core/services/HashHelper.dart';
import '../../core/services/user.dart';
import '../../ui/shared/logger.dart';

class DatabaseHelper {
  // Singleton Database Helper
  final log = getLogger('DatabaseHelper');
  static DatabaseHelper _databaseHelper;

  DatabaseHelper._createInstance(); // Named constructer to create instance of DatabaseHelper
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); //Executed only once, singleton object
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB(); // if _database is null we instantiate it
    }
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "qrcode.db");
//    getLogger("initDB: before open path, $path, ${DateTime.now()}");
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int newversion) async {
// getLogger("_createDB: before CREATE TABLE, ${DateTime.now()}");

    await db.execute("CREATE TABLE AppUser (" // Create table
//        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "email TEXT PRIMARY KEY,"
        "password TEXT,"
        "serverConnect INTEGER,"
        "serverURL Text,"
        "keepLocalHistory INTEGER,"
        "inAppBrowsing INTEGER,"
        "field1Label TEXT,"
        "field2Label TEXT,"
        "field3Label TEXT,"
        "daysLocalHistory INTEGER,"
        "daysServerHistory INTEGER"
        ")");

    final newAppUser = AppUser.dummy();
//        //Add default user after database create
 getLogger("_createDB: before INSERT newAppUser, dummy Password = ${newAppUser.password}, ${DateTime.now()}");

    await db.rawInsert(
        'INSERT INTO AppUser( email, password, serverConnect, ServerURL, keepLocalHistory, '
        'inAppBrowsing, field1Label, field2Label, field3Label, daysLocalHistory, daysServerHistory) '
        'VALUES("${newAppUser.email}","${newAppUser.password}", ${newAppUser.serverConnect}, '
        '"${newAppUser.serverURL}", ${newAppUser.keepLocalHistory}, ${newAppUser.inAppBrowsing}, '
        '"${newAppUser.field1Label}", "${newAppUser.field2Label}", "${newAppUser.field3Label}", '
        '${newAppUser.daysLocalHistory}, ${newAppUser.daysServerHistory})');

    loggedInUserData.email = newAppUser.email;
    loggedInUserData.password = newAppUser.password;
    loggedInUserData.serverConnect = newAppUser.serverConnect;
    loggedInUserData.serverURL = newAppUser.serverURL;
    loggedInUserData.keepLocalHistory = newAppUser.keepLocalHistory;
    loggedInUserData.field1Label = newAppUser.field1Label;
    loggedInUserData.field2Label = newAppUser.field2Label;
    loggedInUserData.field3Label = newAppUser.field3Label;
    loggedInUserData.daysLocalHistory = newAppUser.daysLocalHistory;
    loggedInUserData.daysServerHistory = newAppUser.daysServerHistory;

// getLogger("_createDB: before CREATE TABLE QRCodeHistory, ${DateTime.now()}");

    await db.execute("CREATE TABLE QRCodeHistory (" // Create table
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "scanDate TEXT,"
        "scanTime TEXT,"
        "scanQRCode TEXT,"
        "scanUsed INTEGER,"
        "field1 DECIMAL,"
        "field2 TEXT,"
        "field3 TEXT,"
        "daysLocalHistory INTEGER,"
        "daysServerHistory INTEGER"
        ")");
  }

  Future closeDB() async {
    Database db = await this.database;
    await db.close();
  }

  static void deleteDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "qrcode.db");
    try {
      File dbFile = File.fromUri(Uri.file(path));
      dbFile.delete();
//      print("Deleted db file.");
    } catch (e) {}
  }

  newAppUser(AppUser newAppUser) async {
    Database db = await this.database;
    var res = await db.insert("AppUser", newAppUser.toMap());
//    getLogger("newAppUser: after INSERT newAppUser, ${DateTime.now()}");
    return res;
  }

  updateAppUser(AppUser newAppUser) async {
    Database db = await this.database;
    var res = await db.update("AppUser", newAppUser.toMap(),
        where: "email = ?", whereArgs: [loggedInUserData.email]);
    getLogger("updateAppUser: after db.update, res $res ${DateTime.now()}");
//    String sql = "UPDATE AppUser SET email = ?, password = ?, serverConnect = ?, serverURL = ?, WHERE email = '${loggedInUserData.email}',['${newAppUser.email}', '${newAppUser.password}', ${newAppUser.serverConnect}, '${newAppUser.serverURL}']";
//    int count = await db.rawUpdate(sql);
    return res;
  }

  getAllAppUsers() async {
    Database db = await this.database;
    var res = await db.query("AppUser");
    List<AppUser> list =
        res.isNotEmpty ? res.map((c) => AppUser.fromMap(c)).toList() : [];
    return list;
  }

  deleteAppUser(int email) async {
    Database db = await this.database;
    return db.delete("AppUser", where: "email = ?", whereArgs: [email]);
  }

  getAppUser(String forEmail) async {
    String lowerEmail = forEmail.toLowerCase();
    Database db = await this.database;
    var res =
        await db.query("AppUser", where: "email = ?", whereArgs: [lowerEmail]);
//    List<AppUser> list = res.isNotEmpty ? res.map((c) => AppUser.fromMap(c)).toList() : [];
//    return list;
    getLogger("getAppUser: res, $res, ${DateTime.now()}");
    return res.isNotEmpty ? AppUser.fromMap(res.first) : Null;
  }

  getFirstAppUser() async {
    Database db = await this.database;
    var res = await db.query("AppUser", where: "email = ?", whereArgs: ["*"]);
//    List<AppUser> list = res.isNotEmpty ? res.map((c) => AppUser.fromMap(c)).toList() : [];
//    return list;
    return res.isNotEmpty ? AppUser.fromMap(res.first) : Null;
  }

  getServerConnect() async {
    // before any login has been attempted, check first user record to see if we need to login
    bool _success;
    // getFirstAppUser().then((AppUser currentUser) {
    Database db = await this.database;
//      var res = await db.query("AppUser", where: "email = ?", whereArgs: ["*"]);
    var res = await db.query("AppUser");
    AppUser currentUser = AppUser.fromMap(res.first);

    if (currentUser == null) {
      getLogger("canLogin:currentUser == null, ${DateTime.now()}");
      _success = false;
    } else {
      if (currentUser.serverConnect == 0) {
        // i.e. true - proceed to login
        _success = true;
        getLogger(
            "getServerConnect: first record: ${currentUser.email}, returned $_success, go to login");
      } else {
        // == 1, cannot connect i.e. false
        _success = false;
        getLogger(
            "getServerConnect: first record: ${currentUser.email}, returned $_success, go to scan page");
      }
      loggedInUserData.email = currentUser.email;
      loggedInUserData.password = currentUser.password;
      loggedInUserData.serverConnect = currentUser.serverConnect;
      loggedInUserData.serverURL = currentUser.serverURL;
      loggedInUserData.keepLocalHistory = currentUser.keepLocalHistory;
      loggedInUserData.inAppBrowsing = currentUser.inAppBrowsing;
      loggedInUserData.field1Label = currentUser.field1Label;
      loggedInUserData.field2Label = currentUser.field2Label;
      loggedInUserData.field3Label = currentUser.field3Label;
      loggedInUserData.daysLocalHistory = currentUser.daysLocalHistory;
      loggedInUserData.daysServerHistory = currentUser.daysServerHistory;

      getLogger(
          "getServerConnect: singleton email: ${loggedInUserData.email}, returned $_success, go to scan page");
    }
    getLogger("getServerConnect: returned $_success");
    return _success;
  }




  canLogin(String forEmail, String typedInPassword) async {

    getLogger("canLogin, ${DateTime.now()}");
    if (typedInPassword == null) {
      // || ((typedInPassword.length()) == 0) {
      getLogger("canLogin: null password, ${DateTime.now()}");
      return "Missing password";
    }
      getLogger("canLogin: Username, $forEmail, Password, $typedInPassword, ${DateTime.now()}");

    
    var currentUser = await getAppUser(forEmail);

    if (currentUser == null) {
      getLogger("canLogin: Unknown username, $forEmail  ${DateTime.now()}");
      return "Unknown user email $forEmail.";

    } else {
      
      getLogger("canLogin: retreived email, ${currentUser.email} retrieved password, ${currentUser.password}, ${DateTime.now()}");

      var hashedPassword = HashHelper.getHash(typedInPassword.trim());
      getLogger("canLogin: hashed password, $hashedPassword ${DateTime.now()}");
      
      var savedPassword = currentUser.password; // utf8.encode(currentUser.encryptedPassword);

      if (hashedPassword.length != savedPassword.length) {
        // toDo: Setup New Usercode
        getLogger("canLogin: Bad password (short), ${DateTime.now()}");
        return "Bad password (short)";
      }

      if (savedPassword.compareTo(hashedPassword) != 0) {
        getLogger("canLogin: Bad password, database password $savedPassword, typed in password $typedInPassword hashed, $hashedPassword ${DateTime.now()}");
        return "Bad password";
      }

      loggedInUserData.email = currentUser.email;
      loggedInUserData.password = currentUser.password;
      loggedInUserData.serverConnect = currentUser.serverConnect;
      loggedInUserData.serverURL = currentUser.serverURL;
      loggedInUserData.keepLocalHistory = currentUser.keepLocalHistory;
      loggedInUserData.inAppBrowsing = currentUser.inAppBrowsing;
      loggedInUserData.field1Label = currentUser.field1Label;
      loggedInUserData.field2Label = currentUser.field2Label;
      loggedInUserData.field3Label = currentUser.field3Label;
      loggedInUserData.daysLocalHistory = currentUser.daysLocalHistory;
      loggedInUserData.daysServerHistory = currentUser.daysServerHistory;

      getLogger("canLogin: email: ${loggedInUserData.email}");

      return " ";
    }
  }

  Future<int> newQRCodeHistory(QRCodeHistory newQRCodeHistory) async {
    Database db = await this.database;
    var res = await db.insert("QRCodeHistory", newQRCodeHistory.toMap());
    return res;
  }

  Future<int> updateQRCodeHistory(QRCodeHistory newQRCodeHistory) async {
    Database db = await this.database;
    var res = await db.update("QRCodeHistory", newQRCodeHistory.toMap(),
        where: "id = ?", whereArgs: [newQRCodeHistory.id]);
    return res;
  }

  Future<int> updateQRCodeHistoryUsed(int _localRowid, int _scanUsed) async {
    Database db = await this.database;
    var res = await db.rawUpdate('''
        UPDATE QRCodeHistory 
        SET scanUsed = ?
        WHERE ROWID = ?
        ''', 
        [_scanUsed, _localRowid]);
//    var res = await db.update("QRCodeHistory", newQRCodeHistory.toMap(),
//        where: "id = ?", whereArgs: [_localRowid]);
    return res;
  }

  Future<List<QRCodeHistory>> getAllQRCodeHistorys() async {
    Database db = await this.database;
    var res = await db.query("QRCodeHistory");
    List<QRCodeHistory> list =
        res.isNotEmpty ? res.map((c) => QRCodeHistory.fromMap(c)).toList() : [];
    return list;
  }

  getLastQRCodeHistory() async {
    Database db = await this.database;
    var res = await db.query("QRCodeHistory");
    return res.isNotEmpty ? AppUser.fromMap(res.last) : Null;
  }

  deleteQRCodeHistory(int id) async {
    Database db = await this.database;
    return db.delete("QRCodeHistory", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    Database db = await this.database;
    db.rawDelete("Delete * from QRCodeHistory");
  }
}

