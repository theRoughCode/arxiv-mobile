import 'package:xml/xml.dart';

class Article {
  final String id;
  final DateTime updated;
  final DateTime published;
  final String title;
  final String summary;
  final List<String> authors;
  final String doi;
  final String doiUrl;
  final String comment;
  final String journalRef;
  final List<String> categories;
  final String articleUrl;
  final String pdfUrl;

  Article(
    this.id,
    this.updated,
    this.published,
    this.title,
    this.summary,
    this.authors,
    this.doi,
    this.doiUrl,
    this.comment,
    this.journalRef,
    this.categories,
    this.articleUrl,
    this.pdfUrl,
  );

  Article.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        updated = json['updated'],
        published = json['published'],
        title = json['title'],
        summary = json['summary'],
        authors = json['authors'],
        doi = json['doi'],
        doiUrl = json['doiUrl'],
        comment = json['comment'],
        journalRef = json['journalRef'],
        categories = json['categories'],
        articleUrl = json['articleUrl'],
        pdfUrl = json['pdfUrl'];

  factory Article.fromEntry(XmlElement entry) {
    var articleUrl, pdfUrl, doiUrl;

    // Retrieve links
    entry.findElements('link').forEach((element) {
      switch (element.getAttribute('title')) {
        case 'doi':
          doiUrl = element.getAttribute('href');
          break;
        case 'pdf':
          pdfUrl = element.getAttribute('href');
          break;
        default:
          articleUrl = element.getAttribute('href');
      }
    });

    Map<String, dynamic> json = {
      'id': entry
          .findElements('id')
          .first
          .text
          ?.trim()
          ?.replaceFirst('http://arxiv.org/abs/', ''),
      'updated':
          DateTime.parse(_getTextFromElements(entry.findElements('updated'))),
      'published':
          DateTime.parse(_getTextFromElements(entry.findElements('published'))),
      'title':
          replaceLaTeXDelims(_getTextFromElements(entry.findElements('title'))),
      'summary': replaceLaTeXDelims(
          _getTextFromElements(entry.findElements('summary'))),
      'authors': entry
          .findElements('author')
          .map((node) => _getTextFromElements(node.findElements('name')))
          .toList(),
      'doi': _getTextFromElements(entry.findElements('arxiv:doi')),
      'doiUrl': doiUrl,
      'comment': _getTextFromElements(entry.findElements('arxiv:comment')),
      'journalRef':
          _getTextFromElements(entry.findElements('arxiv:journal_ref')),
      'categories': entry
          .findElements('category')
          .map((node) => node.getAttribute('term'))
          .where((cat) => cat.startsWith(new RegExp(r'[A-Za-z]')))
          .toList(),
      'articleUrl': articleUrl,
      'pdfUrl': pdfUrl,
    };

    return Article.fromJson(json);
  }
}

String replaceLaTeXDelims(String text) => text.replaceAllMapped(
    new RegExp(r"\$(.*?)\$"), (Match m) => "\\(${m[1]}\\)");

String _getTextFromElements(Iterable<XmlElement> elems) =>
    (elems.length == 0 || elems.first == null)
        ? null
        : elems.first.text
            .trim()
            .replaceAll('\n', ' ')
            .replaceAll(new RegExp('\\s\\s+'), ' ');
