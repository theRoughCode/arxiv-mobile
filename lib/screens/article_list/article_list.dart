import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/screens/article_details/article_details_screen.dart';
import 'package:arxiv_mobile/screens/curated/components/article_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleList extends StatefulWidget {
  final List<Article> articleList;
  final Function(Article) onDismiss;
  final bool renderFavourite;

  const ArticleList({
    Key key,
    @required this.articleList,
    this.onDismiss,
    this.renderFavourite = false,
  }) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.articleList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final int count =
            widget.articleList.length > 10 ? 10 : widget.articleList.length;
        final Animation<double> animation =
            Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              (1 / count) * index,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );
        animationController.forward();

        final article = widget.articleList[index];
        final onDismiss =
            (widget.onDismiss != null) ? () => widget.onDismiss(article) : null;

        return ArticleCard(
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailsScreen(article: article),
              ),
            );
          },
          article: article,
          animation: animation,
          animationController: animationController,
          onDismiss: onDismiss,
          renderFavourite: widget.renderFavourite,
        );
      },
    );
  }
}
