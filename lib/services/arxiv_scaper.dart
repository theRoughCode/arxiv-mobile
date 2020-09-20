import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/arxiv_query.dart';
import 'package:arxiv_mobile/models/category_group.dart';
import 'package:xml/xml.dart' as xml;

class ArxivScraper {
  static const MAX_RESULTS = 10;

  // Fetch all articles given list of categories
  static Future<ScrapeResults> fetchArticlesFromCategories(
      List<String> categories,
      {String search,
      SortBy sortBy = SortBy.lastUpdatedDate,
      SortOrder sortOrder,
      int start,
      int maxResults}) async {
    var searchQuery =
        (search == null || search.length == 0) ? "" : "all:$search";
    if (categories.length > 0) {
      if (searchQuery.length > 0) searchQuery += "+AND+";
      searchQuery += categories.join("+OR+");
    }
    final response = await ArxivQuery(
            query: searchQuery,
            sortBy: sortBy,
            sortOrder: sortOrder,
            start: start,
            maxResults: maxResults)
        .fetch();
    final parsedXml = xml.parse(response);
    final numResults = int.parse(
        parsedXml.findAllElements("opensearch:totalResults").first.text);
    final articles = parsedXml
        .findAllElements('entry')
        .map((e) => Article.fromEntry(e))
        .toList();

    return ScrapeResults(numResults, articles);
  }

  // Fetch all articles
  static Future<ScrapeResults> fetchAllArticles(
      {String search,
      SortBy sortBy = SortBy.lastUpdatedDate,
      SortOrder sortOrder,
      int start,
      int maxResults}) async {
    final List<String> categories =
        CategoryGroup.categoryGroupList.map((e) => "cat:${e.id}*").toList();
    return fetchArticlesFromCategories(
      categories,
      search: search,
      sortBy: sortBy,
      sortOrder: sortOrder,
      start: start,
      maxResults: maxResults,
    );
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
  ArxivScraper.fetchAllArticles()
      .then((value) => value.articles.forEach((element) {
            print(element.title);
          }));
}

class ScrapeResults {
  ScrapeResults(this.numResults, this.articles);

  final int numResults;
  final List<Article> articles;
}
