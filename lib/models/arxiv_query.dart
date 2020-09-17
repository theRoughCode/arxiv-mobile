import 'package:http/http.dart' as http;

enum SortBy { relevance, lastUpdatedDate, submittedDate }

enum SortOrder { ascending, descending }

String _enumToString(Object o) =>
    o != null ? o.toString().split('.').last : null;

class ArxivQuery {
  final String query;
  final List<String> idList;
  final SortBy sortBy;
  final SortOrder sortOrder;
  final int maxResults;
  final int start;

  ArxivQuery(
      {this.query,
      this.idList,
      this.sortBy,
      this.sortOrder,
      this.maxResults,
      this.start});

  String buildQuery() {
    final queryParams = {
      "search_query": this.query,
      "id_list": this.idList?.join(","),
      "sortBy": _enumToString(this.sortBy),
      "sortOrder": _enumToString(this.sortOrder),
      "max_results": this.maxResults?.toString(),
      "start": this.start?.toString()
    };
    // Filter out null values
    queryParams.removeWhere((key, value) => value == null);
    final queryString =
        queryParams.entries.map((e) => "${e.key}=${e.value}").join("&");
    return "http://export.arxiv.org/api/query?$queryString";
  }

  Future<String> fetch() async {
    final request = this.buildQuery();
    final response = await http.get(request);

    if (response.statusCode == 200) return response.body;
    else throw Exception('Request failed: $request');
  }
}
