import 'package:arxiv_mobile/themes/details_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;

  PdfViewerScreen({Key key, @required this.url}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool loading = true;
  PDFDocument pdf;

  void _loadFromUrl() async {
    setState(() {
      loading = true;
    });
    pdf = await PDFDocument.fromURL(widget.url);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _loadFromUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());

    return Container(
      color: DetailsTheme.nearlyWhite,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
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
          ),
        ),
        Expanded(child: PDFViewer(document: pdf)),
      ]),
    );
  }
}
