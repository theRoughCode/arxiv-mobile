import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/category.dart';
import 'package:arxiv_mobile/models/downloads.dart';
import 'package:arxiv_mobile/models/favourites.dart';
import 'package:arxiv_mobile/screens/article_details/components/article_description.dart';
import 'package:arxiv_mobile/screens/article_details/components/pdf_viewer.dart';
import 'package:arxiv_mobile/themes/details_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Article article;

  ArticleDetailsScreen({Key key, @required this.article}) : super(key: key);

  Future<void> onDownload(
    BuildContext context,
    DownloadsModel model,
    bool isDownloaded,
  ) async {
    final text1 = (isDownloaded)
        ? "Deleting ${article.id}..."
        : "Downloading ${article.id}...";
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text1),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
      ),
    ));

    await model.onDownload(article);
    Scaffold.of(context).hideCurrentSnackBar();

    final text2 =
        (isDownloaded) ? "${article.id} deleted!" : "${article.id} downloaded!";
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text2),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DetailsTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (BuildContext context) => Column(
            children: <Widget>[
              getAppBar(context),
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
                      getDetailsBody(context),
                      getButtonsBar(context),
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
      ),
    );
  }

  Widget getAppBar(BuildContext context) {
    return Padding(
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
                borderRadius:
                    BorderRadius.circular(AppBar().preferredSize.height),
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
          Consumer<FavouritesModel>(
            builder: (_, favouritesModel, __) => IconButton(
              icon: Icon(
                  article.favourited ? Icons.favorite : Icons.favorite_border,
                  color: DetailsTheme.nearlyBlue),
              onPressed: () => favouritesModel.onFavourite(article),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDetailsBody(BuildContext context) {
    return Expanded(
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
                      text: article.id,
                      style: DetailsTheme.caption.copyWith(
                          color: Colors.blue[300],
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(article.articleUrl);
                        }),
                  TextSpan(
                    text: " · " +
                        DateFormat('dd MMM yyyy').format(article.updated),
                    style: DetailsTheme.caption,
                  )
                ],
              ),
            ),
          ),
          Text(
            article.title,
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
              article.authors.join(', '),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 15,
                letterSpacing: 0.27,
                color: DetailsTheme.nearlyBlue,
              ),
            ),
          ),
          Wrap(
            children: article.categories
                .map(
                  (cat) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(
                        cat,
                        style: DetailsTheme.chip,
                      ),
                      backgroundColor: Category.getColour(cat),
                      labelPadding: EdgeInsets.only(left: 6, right: 6),
                    ),
                  ),
                )
                .toList(),
          ),
          ArticleDescription(text: article.summary),
        ],
      ),
    );
  }

  Widget getButtonsBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            child: getDownloadButton(context),
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
                        title: article.id,
                        url: (article.downloaded)
                            ? article.downloadPath
                            : article.pdfUrl,
                        isDownloaded: article.downloaded,
                      ),
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
    );
  }

  Widget getDownloadButton(BuildContext context) => Consumer<DownloadsModel>(
        builder: (_, downloadsModel, __) => OutlineButton(
          onPressed: () =>
              onDownload(context, downloadsModel, article.downloaded),
          color: DetailsTheme.nearlyWhite,
          splashColor: DetailsTheme.nearlyBlue.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: EdgeInsets.all(0),
          child: Icon(
            (article.downloaded) ? Icons.delete : Icons.file_download,
            color: DetailsTheme.nearlyBlue,
            size: 26,
          ),
        ),
      );
}
