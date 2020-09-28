import 'package:arxiv_mobile/themes/details_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class ArticleDescription extends StatefulWidget {
  final String text;

  ArticleDescription({Key key, @required this.text}) : super(key: key);

  @override
  _ArticleDescriptionsState createState() => _ArticleDescriptionsState();
}

class _ArticleDescriptionsState extends State<ArticleDescription>
    with TickerProviderStateMixin {
  final double minHeight = 100.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 1200));
    setState(() {
      opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: opacity,
      curve: Curves.easeInOutCubic,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: TeXView(
          child: TeXViewDocument(widget.text),
          style: TeXViewStyle(
            textAlign: TeXViewTextAlign.Left,
            contentColor: DetailsTheme.body2.color,
            fontStyle: TeXViewFontStyle(
              fontFamily: DetailsTheme.body2.fontFamily,
              fontSize: DetailsTheme.body2.fontSize.round(),
              fontWeight: TeXViewFontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
