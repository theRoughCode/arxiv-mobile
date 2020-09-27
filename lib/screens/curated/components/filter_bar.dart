import 'package:arxiv_mobile/models/curated_filters.dart';
import 'package:arxiv_mobile/screens/curated/components/filters_screen.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/material.dart';

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
