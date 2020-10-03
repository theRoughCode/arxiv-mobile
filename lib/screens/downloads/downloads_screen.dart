import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/downloads.dart';
import 'package:arxiv_mobile/screens/article_list/article_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadsScreen extends StatelessWidget {
  final List<Article> articles;

  const DownloadsScreen({Key key, this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Consumer<DownloadsModel>(
      builder: (_, downloadsModel, __) => RefreshIndicator(
        child: NotificationListener<ScrollNotification>(
          child: ArticleList(
            articleList: articles,
            onDismiss: (article) {
              downloadsModel.remove(article);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${article.id} deleted!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => downloadsModel.add(article),
                ),
              ));
            },
          ),
        ),
        onRefresh: downloadsModel.updateDownloads,
      ),
    );
  }
}
