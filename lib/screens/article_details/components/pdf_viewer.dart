import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String url;
  const PdfViewerScreen({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: const PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ).cachedFromUrl(
        url,
        placeholder: (double progress) =>
            Center(child: CircularProgressIndicator(value: progress / 100.0)),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
