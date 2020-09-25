import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/screens/article_details/article_details_screen.dart';
import 'package:arxiv_mobile/screens/curated/components/article_card.dart';
import 'package:arxiv_mobile/screens/curated/components/search_bar.dart';
import 'package:arxiv_mobile/services/arxiv_scaper.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/material.dart';

import 'components/calendar_popup_view.dart';
import 'components/filters_screen.dart';

class CuratedListScreen extends StatefulWidget {
  final ScrollController controller;

  CuratedListScreen({Key key, @required this.controller}) : super(key: key);

  @override
  _CuratedListScreenState createState() => _CuratedListScreenState();
}

class _CuratedListScreenState extends State<CuratedListScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  String query;
  int numResults = 0;
  bool loading = true;
  List<Article> curatedList = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    getData();
  }

  Future<void> getData({int start, bool append = false}) async {
    final results =
        await ArxivScraper.fetchAllArticles(search: query, start: start);
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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
                        delegate: FilterBar(numResults),
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
        child: ListView.builder(
          itemCount: curatedList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            final int count = curatedList.length > 10 ? 10 : curatedList.length;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            animationController.forward();

            return ArticleCard(
              callback: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailsScreen(article: curatedList[index])));
              },
              article: curatedList[index],
              animation: animation,
              animationController: animationController,
            );
          },
        ),
      ),
      onRefresh: () {
        return getData(start: 0);
      },
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}

class FilterBar extends SliverPersistentHeaderDelegate {
  FilterBar(this.numArticles);

  final int numArticles;

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
                            builder: (BuildContext context) => FiltersScreen(),
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
