import 'dart:collection';

import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/services/db_tables/articles_db.dart';
import 'package:flutter/foundation.dart';

class FavouritesModel extends ChangeNotifier {
  HashSet<String> _ids = HashSet();
  Map<String, Article> _articles = {};

  FavouritesModel() {
    updateFavourites();
  }

  HashSet<String> get ids => _ids;
  UnmodifiableListView<Article> get articles =>
      UnmodifiableListView(_articles.values.toList());

  Future<void> updateFavourites() async {
    // Update list of ids
    final articles = await ArticlesDB.getFavourites();
    _articles = Map.fromIterable(
      articles,
      key: (article) => article.id,
      value: (article) => article,
    );
    _ids = HashSet.from(_articles.keys);
    notifyListeners();
  }

  void onFavourite(Article article) {
    article.favourited = !article.favourited;
    if (article.favourited)
      add(article);
    else
      remove(article);
  }

  void add(Article article) async {
    final id = article.id;
    article.favourited = true;

    // Make sure to create copy and not mutate original
    _ids = HashSet.from(_ids);
    _ids.add(id);
    _articles = Map<String, Article>.from(_articles);
    _articles[id] = article;
    notifyListeners();

    ArticlesDB.addFavourite(article);
  }

  void remove(Article article) {
    final id = article.id;
    article.favourited = false;

    _ids = HashSet.from(_ids);
    _ids.remove(id);
    _articles = Map<String, Article>.from(_articles)..remove(id);
    notifyListeners();

    ArticlesDB.removeFavourite(id);
  }
}
