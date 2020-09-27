import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/screens/article_list/article_list.dart';
import 'package:arxiv_mobile/services/arxiv_scaper.dart';
import 'package:arxiv_mobile/services/db_tables/favourites_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Article> articleList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getFavourites();
  }

  // Retrieve favourited list
  Future<void> getFavourites() async {
    final favouritesList = await FavouritesDB.getFavourites();
    final updatedArticlesList = await ArxivScraper.fetchArticlesById(favouritesList);
    updatedArticlesList.forEach((article) => article.favourited = true);
    setState(() {
      articleList = updatedArticlesList;
      loading = false;
    });
  }

  void onFavourite(Article article) {
    setState(() {
      article.favourited = !article.favourited;
      if (article.favourited) FavouritesDB.addFavourite(article.id);
      else FavouritesDB.removeFavourite(article.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (articleList.length == 0 && loading) {
      return Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      child: NotificationListener<ScrollNotification>(
        child: ArticleList(
          articleList: articleList,
          onFavourite: onFavourite,
        ),
      ),
      onRefresh: getFavourites,
    );
  }
}
