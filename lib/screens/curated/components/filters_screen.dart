import 'package:arxiv_mobile/models/curated_filters.dart';
import 'package:arxiv_mobile/themes/curated_list_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  final List<CuratedFilter> filterList;
  final Function(List<CuratedFilter>) onApply;

  const FiltersScreen(
      {Key key, @required this.filterList, @required this.onApply})
      : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<CuratedFilter> filterList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      // Create local copy of filter list
      filterList = widget.filterList.map((filter) => filter.clone()).toList();
    });
  }

  // Handles toggling of filters
  void onCheckFilter(int index) {
    if (index == 0) {
      if (filterList[0].isSelected) {
        filterList.forEach((d) {
          d.isSelected = false;
        });
      } else {
        filterList.forEach((d) {
          d.isSelected = true;
        });
      }
    } else {
      filterList[index].isSelected = !filterList[index].isSelected;

      int count = 0;
      for (int i = 0; i < filterList.length; i++) {
        if (i != 0) {
          final CuratedFilter data = filterList[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == filterList.length - 1) {
        filterList[0].isSelected = true;
      } else {
        filterList[0].isSelected = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CuratedListTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            const FiltersAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: CategoryListFilter(
                  filterList: filterList,
                  onCheck: (int index) {
                    setState(() {
                      onCheckFilter(index);
                    });
                  },
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: CuratedListTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      widget.onApply(filterList);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FiltersAppBar extends StatelessWidget {
  const FiltersAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CuratedListTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}

class CategoryListFilter extends StatelessWidget {
  final List<CuratedFilter> filterList;
  final Function(int) onCheck;
  CategoryListFilter({Key key, this.filterList, this.onCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Subject Categories',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getListUI(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  // Create UI from filters list
  List<Widget> getListUI() {
    final listUI = filterList
        .asMap()
        .map((i, filter) => MapEntry<int, Widget>(
              i,
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  onTap: () {
                    onCheck(i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            filter.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        CupertinoSwitch(
                          activeColor: filter.isSelected
                              ? CuratedListTheme.buildLightTheme().primaryColor
                              : Colors.grey.withOpacity(0.6),
                          onChanged: (bool value) {
                            onCheck(i);
                          },
                          value: filter.isSelected,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        .values
        .toList();
    listUI.insert(
      1,
      const Divider(
        height: 1,
      ),
    );
    return listUI;
  }
}
