import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Downloader {
  static Future<String> getPath(String articleId) async {
    final dir = await getApplicationDocumentsDirectory();
    // We need to include this hack because the PDF Viewer saves a copy of
    // the PDF file with the characters in the file name after the last '.'.
    final fileName = articleId.replaceAll('.', '-');
    return '${dir.path}/$fileName.pdf';
  }

  static Future<String> downloadArticle(String articleId, String url) async {
    final client = http.Client();
    final resp = await client.get(Uri.parse(url));
    final bytes = resp.bodyBytes;
    final downloadPath = await getPath(articleId);
    final file = File(downloadPath);
    await file.writeAsBytes(bytes);
    return downloadPath;
  }

  static Future<void> deleteArticle(String downloadPath) async {
    final file = File(downloadPath);
    await file.delete();
  }
}
