import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/curated_filters.dart';
import 'package:arxiv_mobile/screens/curated/components/filter_bar.dart';
import 'package:arxiv_mobile/screens/curated/components/results_list.dart';
import 'package:arxiv_mobile/screens/curated/components/search_bar.dart';
import 'package:arxiv_mobile/services/arxiv_scaper.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/material.dart';

class CuratedListScreen extends StatefulWidget {
  final ScrollController controller;

  CuratedListScreen({Key key, @required this.controller}) : super(key: key);

  @override
  _CuratedListScreenState createState() => _CuratedListScreenState();
}

class _CuratedListScreenState extends State<CuratedListScreen> {
  String query;
  int numResults = 0;
  bool loading = true;
  List<Article> curatedList = [];
  List<CuratedFilter> categoryFilterList = CuratedFilter.categoryList;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Retrieve articles from ArXiv API
  Future<void> getData({int start, bool append = false}) async {
    ScrapeResults results;

    if (categoryFilterList[0].isSelected) {
      // All categories
      results =
          await ArxivScraper.fetchAllArticles(search: query, start: start);
    } else {
      final categories = categoryFilterList
          .skip(1)
          .where((category) => category.isSelected)
          .map((category) => category.id)
          .toList();
      results = await ArxivScraper.fetchArticlesFromCategories(categories,
          search: query, start: start);
    }

    setState(() {
      numResults = results.numResults;
      if (append)
        curatedList.addAll(results.articles);
      else
        curatedList = results.articles ?? [];
      loading = false;
    });
  }

  bool _onScrollEnd(ScrollNotification scrollInfo) {
    if (!loading &&
        curatedList.length < numResults &&
        scrollInfo.metrics.extentAfter < 300) {
      setState(() {
        loading = true;
      });
      getData(start: curatedList.length, append: true);
    }
    return false;
  }

  void _onSearch(String text) {
    setState(() {
      loading = true;
      numResults = 0;
      curatedList = [];
      query = text;
    });
    getData();
  }

  void onApplyFilters(List<CuratedFilter> filterList) {
    setState(() {
      categoryFilterList = filterList;
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CuratedListTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: NestedScrollView(
                  controller: widget.controller,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[SearchBar(onSearch: _onSearch)],
                          );
                        }, childCount: 1),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: FilterBar(
                            numResults, categoryFilterList, onApplyFilters),
                      ),
                    ];
                  },
                  body: ResultsList(
                    results: curatedList,
                    loading: loading,
                    onScrollEnd: _onScrollEnd,
                    onRefresh: () => getData(start: 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
