import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String url;
  final bool isDownloaded;
  const PdfViewerScreen({
    Key key,
    @required this.title,
    @required this.url,
    @required this.isDownloaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const pdf = PDF(
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
    );
    final pdfView = (isDownloaded)
        ? pdf.fromAsset(
            url,
            errorWidget: (dynamic error) =>
                Center(child: Text(error.toString())),
          )
        : pdf.cachedFromUrl(
            url,
            placeholder: (double progress) => Center(
                child: CircularProgressIndicator(value: progress / 100.0)),
            errorWidget: (dynamic error) =>
                Center(child: Text(error.toString())),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: pdfView,
    );
  }
}
