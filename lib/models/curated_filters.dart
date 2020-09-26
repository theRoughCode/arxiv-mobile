import 'package:arxiv_mobile/models/category_group.dart';

class CuratedFilter {
  CuratedFilter({
    this.id = '',
    this.name = '',
    this.isSelected = false,
  });

  String id;
  String name;
  bool isSelected;

  static List<CuratedFilter> categoryList = [
    CuratedFilter(id: 'all', name: 'All', isSelected: true)
  ]..addAll(
      CategoryGroup.categoryGroupList.map((categoryGroup) => CuratedFilter(
            id: categoryGroup.id,
            name: categoryGroup.name,
            isSelected: true,
          )));

  CuratedFilter clone() => new CuratedFilter(
      id: this.id, name: this.name, isSelected: this.isSelected);
}
