import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {Key key,
      this.article,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Article article;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  static TextTheme textTheme =
      CuratedListTheme.buildLightTheme().primaryTextTheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: _buildCard(),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    final authorsStr = article.authors.map((a) {
      final names = a.split(' ').take(2).toList();
      if (names.length < 2 || names[1].length == 0) return names.join('');
      return "${names[0]} ${names[1][0].toUpperCase()}.";
    }).join(', ');

    return Card(
      margin: const EdgeInsets.only(top: 8),
      shape: BeveledRectangleBorder(),
      child: InkWell(
        splashColor:
            CuratedListTheme.buildLightTheme().primaryColor.withAlpha(25),
        onTap: () {
          print("Title: ${article.title}");
          callback();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 6, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(article.title, style: textTheme.headline1),
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: Text(
                  authorsStr,
                  style: textTheme.subtitle2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 4),
                child: Text(article.summary,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.0)),
              ),
              Text(article.categories.join(', '), style: textTheme.subtitle2),
            ],
          ),
        ),
      ),
    );
  }
}
