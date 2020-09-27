import 'package:arxiv_mobile/services/db_manager.dart';

class FavouritesDB {
  static const tableName = 'Favourites';
  static const onCreate = 'CREATE TABLE $tableName(id TEXT PRIMARY KEY)';
  
  static final dbManager = DatabaseManager();

  static Future<int> addFavourite(String articleId) async {
    final db = await dbManager.database;
    int id = await db.insert(tableName,  { 'id': articleId });
    print(id);
    return id;
  }

  static Future<int> removeFavourite(String articleId) async {
    final db = await dbManager.database;
    int id = await db.delete(tableName, where: 'id = ?', whereArgs: [articleId]);
    return id;
  }

  static Future<List<String>> getFavourites() async {
    final db = await dbManager.database;
    List<Map> records = await db.query(tableName);
    List<String> favourites = records.map<String>((r) => r['id']).toList();
    return favourites;
  }
}
