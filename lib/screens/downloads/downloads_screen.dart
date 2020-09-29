import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/downloads.dart';
import 'package:arxiv_mobile/models/favourites.dart';
import 'package:arxiv_mobile/screens/article_list/article_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadsScreen extends StatelessWidget {
  final List<Article> articles;

  const DownloadsScreen({Key key, this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: NotificationListener<ScrollNotification>(
        child: ArticleList(
          articleList: articles,
          onFavourite:
              Provider.of<FavouritesModel>(context).onFavourite,
        ),
      ),
      onRefresh:
          Provider.of<DownloadsModel>(context).updateDownloads,
    );
  }
}
