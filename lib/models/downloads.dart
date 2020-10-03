import 'dart:collection';

import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/services/db_tables/articles_db.dart';
import 'package:arxiv_mobile/services/downloader.dart';
import 'package:flutter/foundation.dart';

class DownloadsModel extends ChangeNotifier {
  HashSet<String> _ids = HashSet();
  Map<String, Article> _articles = {};

  DownloadsModel() {
    updateDownloads();
  }

  HashSet<String> get ids => _ids;
  UnmodifiableListView<Article> get articles =>
      UnmodifiableListView(_articles.values.toList());

  Future<void> updateDownloads() async {
    // Update list of ids
    final articles = await ArticlesDB.getDownloads();
    _articles = Map.fromIterable(
      articles,
      key: (article) => article.id,
      value: (article) => article,
    );
    _ids = HashSet.from(_articles.keys);
    notifyListeners();
  }

  Future<void> onDownload(Article article) async {
    article.downloaded = !article.downloaded;
    if (article.downloaded)
      await add(article);
    else
      await remove(article);
  }

  Future<void> add(Article article) async {
    final path = await Downloader.downloadArticle(article.id, article.pdfUrl);
    article.downloaded = true;
    article.downloadPath = path;

    final id = article.id;
    // Make sure to create copy and not mutate original
    _ids = HashSet.from(_ids);
    _ids.add(id);
    _articles = Map<String, Article>.from(_articles);
    _articles[id] = article;
    notifyListeners();

    ArticlesDB.addDownload(article);
  }

  Future<void> remove(Article article) async {
    await Downloader.deleteArticle(article.downloadPath);
    article.downloaded = false;
    article.downloadPath = null;

    final id = article.id;
    _ids = HashSet.from(_ids);
    _ids.remove(id);
    _articles = Map<String, Article>.from(_articles)..remove(id);
    notifyListeners();

    ArticlesDB.removeDownload(id);
  }
}
