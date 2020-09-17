import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/material.dart';

class CuratedListView extends StatelessWidget {
  const CuratedListView(
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
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: _buildCard(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return Card(
        child: InkWell(
            splashColor:
                CuratedListTheme.buildLightTheme().primaryColor.withAlpha(25),
            onTap: () {
              print("Title: ${article.title}");
            },
            child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: ListTile(
                  title: Text(article.title),
                  subtitle: Text(
                    article.summary,
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))));
  }
}
