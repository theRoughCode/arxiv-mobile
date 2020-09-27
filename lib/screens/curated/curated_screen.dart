import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/curated_filters.dart';
import 'package:arxiv_mobile/screens/article_list/article_list.dart';
import 'package:arxiv_mobile/screens/curated/components/search_bar.dart';
import 'package:arxiv_mobile/services/arxiv_scaper.dart';
import 'package:arxiv_mobile/services/db_tables/favourites_db.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/material.dart';

import 'components/filters_screen.dart';

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
  Map<String, bool> favouritedList = {};
  List<CuratedFilter> categoryFilterList = CuratedFilter.categoryList;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    init();
  }

  // Retrieve favourited list and initial list of data
  void init() async {
    final favourites = await FavouritesDB.getFavourites();
    favouritedList = {};
    favourites.forEach((id) => favouritedList[id] = true);
    await getData();
  }

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

    results.articles.forEach((article) {
      if (favouritedList.containsKey(article.id)) article.favourited = true;
    });

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

  void onFavourite(Article article) {
    setState(() {
      article.favourited = !article.favourited;
      if (article.favourited) {
        favouritedList[article.id] = true;
        FavouritesDB.addFavourite(article.id);
      } else if (favouritedList.containsKey(article.id)) {
        favouritedList.remove(article.id);
        FavouritesDB.removeFavourite(article.id);
      }
    });
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
                  body: getListUI(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListUI() {
    if (curatedList.length == 0 && loading) {
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollEnd,
        child: ArticleList(
          articleList: curatedList,
          onFavourite: onFavourite,
        ),
      ),
      onRefresh: () {
        return getData(start: 0);
      },
    );
  }
}

class FilterBar extends SliverPersistentHeaderDelegate {
  FilterBar(this.numArticles, this.filterList, this.onApply);

  final int numArticles;
  final List<CuratedFilter> filterList;
  final Function(List<CuratedFilter>) onApply;

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: CuratedListTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: CuratedListTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '$numArticles articles found',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(
                                  filterList: filterList,
                                  onApply: onApply,
                                ),
                            fullscreenDialog: true),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.sort,
                              color: CuratedListTheme.buildLightTheme()
                                  .primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }
}
