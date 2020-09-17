import 'package:arxiv_mobile/models/arxiv_query.dart';
import 'package:test/test.dart';

void main() {
  test('Query keyword', () {
    final query = ArxivQuery(query: "electron");
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?search_query=electron");
  });

  test('Query id list', () {
    final query = ArxivQuery(idList: ["a", "b", "c"]);
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?id_list=a,b,c");
  });

  test('Query keyword and id list', () {
    final query = ArxivQuery(query: "electron", idList: ["a", "b", "c"]);
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?search_query=electron&id_list=a,b,c");
  });

  test('Query with sort by', () {
    final query = ArxivQuery(sortBy: SortBy.lastUpdatedDate);
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?sortBy=lastUpdatedDate");
  });

  test('Query with sort order', () {
    final query = ArxivQuery(sortOrder: SortOrder.ascending);
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?sortOrder=ascending");
  });

  test('Query with max results', () {
    final query = ArxivQuery(maxResults: 5);
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?max_results=5");
  });

  test('Query with start index', () {
    final query = ArxivQuery(start: 10);
    expect(query.buildQuery(), "http://export.arxiv.org/api/query?start=10");
  });
}
