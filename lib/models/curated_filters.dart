  
class CuratedFilter {
  CuratedFilter({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<CuratedFilter> curatedFiltersList = <CuratedFilter>[
    CuratedFilter(
      titleTxt: 'Free Breakfast',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Free Parking',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Pool',
      isSelected: true,
    ),
    CuratedFilter(
      titleTxt: 'Pet Friendly',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Free wifi',
      isSelected: false,
    ),
  ];

  static List<CuratedFilter> accomodationList = [
    CuratedFilter(
      titleTxt: 'All',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Home',
      isSelected: true,
    ),
    CuratedFilter(
      titleTxt: 'Villa',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Hotel',
      isSelected: false,
    ),
    CuratedFilter(
      titleTxt: 'Resort',
      isSelected: false,
    ),
  ];
}
