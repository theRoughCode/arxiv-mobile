import 'dart:collection';

import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/services/db_tables/articles_db.dart';
import 'package:flutter/foundation.dart';

class DownloadsModel extends ChangeNotifier {
  Set<String> _ids = {};
  Map<String, Article> _articles = {};

  DownloadsModel() {
    updateDownloads();
  }

  Set<String> get ids => _ids;
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
    _ids = Set.from(_articles.keys);
    notifyListeners();
  }

  void onDownload(Article article) {
    article.downloaded = !article.downloaded;
    if (article.downloaded)
      add(article);
    else
      remove(article);
  }

  void add(Article article) async {
    final id = article.id;
    article.downloaded = true;

    // Make sure to create copy and not mutate original
    _ids = _ids.union({id});
    _articles = Map<String, Article>.from(_articles);
    _articles[id] = article;
    notifyListeners();

    ArticlesDB.addDownload(article);
  }

  void remove(Article article) {
    final id = article.id;
    article.downloaded = false;

    _ids = _ids.difference({id});
    _articles = Map<String, Article>.from(_articles)
      ..removeWhere((key, value) => key == id);
    notifyListeners();

    ArticlesDB.removeDownload(id);
  }
}
