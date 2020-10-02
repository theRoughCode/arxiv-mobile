import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/favourites.dart';
import 'package:arxiv_mobile/screens/article_list/article_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Article> articles;

  const FavouritesScreen({Key key, this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouritesModel>(
      builder: (_, favouritesModel, __) => RefreshIndicator(
        child: NotificationListener<ScrollNotification>(
          child: ArticleList(
            articleList: articles,
            onDismiss: (article) {
              favouritesModel.remove(article);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${article.id} removed!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => favouritesModel.add(article),
                ),
              ));
            },
          ),
        ),
        onRefresh: favouritesModel.updateFavourites,
      ),
    );
  }
}
