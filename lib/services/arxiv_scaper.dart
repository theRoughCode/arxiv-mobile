import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/arxiv_query.dart';
import 'package:arxiv_mobile/models/category_group.dart';
import 'package:xml/xml.dart' as xml;

class ArxivScraper {
  static const MAX_RESULTS = 10;

  // Fetch all articles given list of categories
  static Future<List<Article>> fetchArticlesFromCategories(
      List<String> categories,
      {sortBy = SortBy.lastUpdatedDate,
      sortOrder,
      start,
      maxResults}) async {
    final searchQuery = categories.join("+OR+");
    final response = await ArxivQuery(
            query: searchQuery,
            sortBy: sortBy,
            sortOrder: sortOrder,
            start: start,
            maxResults: maxResults)
        .fetch();
    
    return xml
        .parse(response)
        .findAllElements('entry')
        .map((e) => Article.fromEntry(e))
        .toList();
  }

  // Fetch all articles
  static Future<List<Article>> fetchAllArticles(
      {sortBy = SortBy.lastUpdatedDate, sortOrder, start, maxResults}) async {
    final List<String> categories =
        CategoryGroup.categoryGroupList.map((e) => "cat:${e.id}*").toList();
    return fetchArticlesFromCategories(categories,
        sortBy: sortBy,
        sortOrder: sortOrder,
        start: start,
        maxResults: maxResults);
  }

  // Fetch an article by its ID
  static Future<Article> fetchArticleById(String id) async {
    final response = await ArxivQuery(idList: [id]).fetch();
    final entry = xml.parse(response).findAllElements('entry').first;
    return Article.fromEntry(entry);
  }
}

void main(List<String> args) {
  // Future<Article> futureArticle =
  //     ArxivScraper.fetchArticleById('cond-mat/0002322v1');
  // futureArticle.then((value) => print(value.title));
  ArxivScraper.fetchAllArticles().then((value) => value.forEach((element) {
        print(element.title);
      }));
}
