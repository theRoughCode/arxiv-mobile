import 'dart:collection';

import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/services/arxiv_scaper.dart';
import 'package:arxiv_mobile/services/db_tables/favourites_db.dart';
import 'package:flutter/foundation.dart';

class FavouritesModel extends ChangeNotifier {
  Set<String> _ids = {};
  Map<String, Article> _articles = {};

  FavouritesModel() {
    updateFavourites();
  }

  Set<String> get ids => _ids;
  UnmodifiableListView<Article> get articles =>
      UnmodifiableListView(_articles.values.toList());

  Future<void> updateFavourites() async {
    // Update list of ids
    final updatedIds = await FavouritesDB.getFavourites();
    _ids = Set.from(updatedIds);
    notifyListeners();

    // Retrieve articles
    final updatedArticles = await ArxivScraper.fetchArticlesById(updatedIds);
    _articles = Map.fromIterable(
      updatedArticles,
      key: (article) => article.id,
      value: (article) => article..favourited = true,
    );
    notifyListeners();
  }

  void onFavourite(Article article) {
    article.favourited = !article.favourited;
    if (article.favourited)
      add(article.id);
    else
      remove(article.id);
  }

  void add(String id) async {
    _ids.add(id);
    notifyListeners();

    FavouritesDB.addFavourite(id);
    final article = await ArxivScraper.fetchArticleById(id);
    _articles[id] = article..favourited = true;
    notifyListeners();
  }

  void remove(String id) {
    _ids.remove(id);
    _articles.remove(id);
    FavouritesDB.removeFavourite(id);
    notifyListeners();
  }
}
