import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/favourites.dart';
import 'package:arxiv_mobile/screens/article_list/article_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultsList extends StatelessWidget {
  final List<Article> results;
  final bool loading;
  final Function(ScrollNotification) onScrollEnd;
  final VoidCallback onRefresh;

  const ResultsList({
    Key key,
    @required this.results,
    @required this.loading,
    @required this.onScrollEnd,
    @required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (results.length == 0 && loading) {
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      child: NotificationListener<ScrollNotification>(
        onNotification: onScrollEnd,
        child: Selector<FavouritesModel, Set<String>>(
          selector: (_, model) => model.ids,
          builder: (_, ids, __) => ArticleList(
            articleList: results
                .map(
                    (article) => article..favourited = ids.contains(article.id))
                .toList(),
            onFavourite: Provider.of<FavouritesModel>(context).onFavourite,
          ),
        ),
      ),
      onRefresh: onRefresh,
    );
  }
}
