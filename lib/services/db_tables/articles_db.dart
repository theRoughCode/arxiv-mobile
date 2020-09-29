import 'dart:async';

import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/services/db_manager.dart';

class ArticlesDB {
  static const tableName = 'Articles';
  static const onCreate = '''CREATE TABLE $tableName(
        id TEXT PRIMARY KEY,
        updated DATETIME,
        published DATETIME,
        title TEXT,
        summary TEXT,
        authors TEXT,
        doi TEXT,
        doiUrl TEXT,
        comment TEXT,
        journalRef TEXT,
        categories TEXT,
        articleUrl TEXT,
        pdfUrl TEXT,
        downloadPath TEXT,
        favourited INTEGER,
        downloaded INTEGER)''';

  static final dbManager = DatabaseManager();

  static Future<int> addArticle(Article article) async {
    final db = await dbManager.database;
    int id = await db.insert(tableName, article.toMap());
    return id;
  }

  static Future<int> updateArticle(Article article) async {
    final db = await dbManager.database;
    final map = article.toMap();
    var id = await db.update(tableName, map);
    if (id == 0) id = await db.insert(tableName, map);
    return id;
  }

  static Future<int> removeArticle(String articleId) async {
    final db = await dbManager.database;
    int id =
        await db.delete(tableName, where: 'id = ?', whereArgs: [articleId]);
    return id;
  }

  static Future<Article> getArticle(String id) async {
    final db = await dbManager.database;
    List<Map> records =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (records.length == 0) return null;
    return Article.fromMap(records.first);
  }

  static Future<List<Article>> getArticles() async {
    final db = await dbManager.database;
    List<Map> records = await db.query(tableName);
    List<Article> articles =
        records.map<Article>((r) => Article.fromMap(r)).toList();
    return articles;
  }

  static Future<List<Article>> getFavourites() async {
    final db = await dbManager.database;
    List<Map> records =
        await db.query(tableName, where: 'favourited = ?', whereArgs: [1]);
    List<Article> articles =
        records.map<Article>((r) => Article.fromMap(r)).toList();
    return articles;
  }

  static Future<int> addFavourite(Article article) async {
    final db = await dbManager.database;
    // Try updating if row exists
    var id = await db.update(tableName, {'favourited': 1},
        where: 'id = ?', whereArgs: [article.id]);
    if (id == 0) id = await addArticle(article);
    return id;
  }

  static Future<int> removeFavourite(String articleId) async {
    final article = await getArticle(articleId);

    // Article does not exist
    if (article == null) return 0;

    // Article is not downloaded, so remove from db
    if (!article.downloaded) return await removeArticle(articleId);

    // Otherwise, update row
    final db = await dbManager.database;
    return await db.update(tableName, {'favourited': 0},
        where: 'id = ?', whereArgs: [articleId]);
  }

  static Future<List<Article>> getDownloads() async {
    final db = await dbManager.database;
    List<Map> records =
        await db.query(tableName, where: 'downloaded = ?', whereArgs: [1]);
    List<Article> articles =
        records.map<Article>((r) => Article.fromMap(r)).toList();
    return articles;
  }

  static Future<int> addDownload(Article article) async {
    final db = await dbManager.database;
    // Try updating if row exists
    var id = await db.update(tableName, {'downloaded': 1},
        where: 'id = ?', whereArgs: [article.id]);
    if (id == 0) id = await addArticle(article);
    return id;
  }

  static Future<int> removeDownload(String articleId) async {
    final article = await getArticle(articleId);

    // Article does not exist
    if (article == null) return 0;

    // Article is not downloaded, so remove from db
    if (!article.downloaded) return await removeArticle(articleId);

    // Otherwise, update row
    final db = await dbManager.database;
    return await db.update(tableName, {'downloaded': 0},
        where: 'id = ?', whereArgs: [articleId]);
  }
}
