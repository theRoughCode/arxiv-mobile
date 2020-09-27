import 'dart:async';
import 'package:arxiv_mobile/services/db_tables/favourites_db.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const DATABASE_NAME = "arxiv_mobile.db";

class DatabaseManager {
  static final DatabaseManager _dbManager = DatabaseManager._internal();
  static Database _database;
  final _initDBMemoizer = AsyncMemoizer<Database>();

  factory DatabaseManager() {
    return _dbManager;
  }

  DatabaseManager._internal() {
    // Call to database to initiate db initialization
    this.database;
  }

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDBMemoizer.runOnce(() async => await initDB());
    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        print("Creating database!");
        // Table for storing favourites
        db.execute(FavouritesDB.onCreate);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
