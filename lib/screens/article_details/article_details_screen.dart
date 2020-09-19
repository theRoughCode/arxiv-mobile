import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/category.dart';
import 'package:arxiv_mobile/screens/article_details/components/pdf_viewer.dart';
import 'package:arxiv_mobile/themes/details_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final Article article;
  final bool favourited;

  ArticleDetailsScreen(
      {Key key, @required this.article, this.favourited = false})
      : super(key: key);

  @override
  _ArticleDetailsScreenState createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen>
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
    return Container(
      color: DetailsTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: AppBar().preferredSize.height,
                    height: AppBar().preferredSize.height,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                            AppBar().preferredSize.height),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: DetailsTheme.nearlyBlack,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                          widget.favourited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: DetailsTheme.nearlyBlue),
                      onPressed: null),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  right: 20,
                  left: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: widget.article.id,
                                      style: DetailsTheme.caption.copyWith(
                                          color: Colors.blue[300],
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch(widget.article.articleUrl);
                                        }),
                                  TextSpan(
                                    text: " · " +
                                        DateFormat('dd MMM yyyy')
                                            .format(widget.article.updated),
                                    style: DetailsTheme.caption,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Text(
                            widget.article.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: DetailsTheme.darkerText,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Text(
                              widget.article.authors.join(', '),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 15,
                                letterSpacing: 0.27,
                                color: DetailsTheme.nearlyBlue,
                              ),
                            ),
                          ),
                          Row(
                            children: widget.article.categories
                                .map(
                                  (cat) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Chip(
                                      label: Text(
                                        cat,
                                        style: DetailsTheme.chip,
                                      ),
                                      backgroundColor: Category.getColour(cat),
                                      labelPadding:
                                          EdgeInsets.only(left: 6, right: 6),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 800),
                            opacity: opacity,
                            curve: Curves.easeInOutCubic,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: TeXView(
                                child: TeXViewDocument(widget.article.summary),
                                style: TeXViewStyle(
                                  textAlign: TeXViewTextAlign.Left,
                                  contentColor: DetailsTheme.body2.color,
                                  fontStyle: TeXViewFontStyle(
                                    fontFamily: DetailsTheme.body2.fontFamily,
                                    fontSize:
                                        DetailsTheme.body2.fontSize.round(),
                                    fontWeight: TeXViewFontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, bottom: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 48,
                            child: OutlineButton(
                              onPressed: () {},
                              color: DetailsTheme.nearlyWhite,
                              splashColor:
                                  DetailsTheme.nearlyBlue.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.file_download,
                                color: DetailsTheme.nearlyBlue,
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                              height: 48,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfViewerScreen(
                                          url: widget.article.pdfUrl),
                                    ),
                                  );
                                },
                                color: DetailsTheme.nearlyBlue,
                                textColor: DetailsTheme.nearlyWhite,
                                child: Text(
                                  'Open PDF',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
