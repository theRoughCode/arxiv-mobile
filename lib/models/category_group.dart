class CategoryGroup {
  CategoryGroup({this.id, this.name});

  String id;
  String name;

  // List of available category groups
  static final List<CategoryGroup> categoryGroupList = <CategoryGroup>[
    CategoryGroup(id: "astro-ph", name: "Astrophysics"),
    CategoryGroup(id: "cond-mat", name: "Condensed Matter"),
    CategoryGroup(id: "cs", name: "Computer Science"),
    CategoryGroup(id: "econ", name: "Economics"),
    CategoryGroup(
        id: "eess", name: "Electrical Engineering and Systems Science"),
    CategoryGroup(
        id: "gr-qc", name: "General Relativity and Quantum Cosmology"),
    CategoryGroup(id: "hep", name: "High Energy Physics"),
    CategoryGroup(id: "math", name: "Mathematics"),
    CategoryGroup(id: "nlin", name: "Nonelinear Sciences"),
    CategoryGroup(id: "physics", name: "Physics"),
    CategoryGroup(id: "q-bio", name: "Quantitative Biology"),
    CategoryGroup(id: "q-fin", name: "Quantitative Finance"),
    CategoryGroup(id: "quant-ph", name: "Quantum Physics"),
    CategoryGroup(id: "stat", name: "Statistics"),
  ];

  // Construct mapping from category group ID to CategoryGroup
  static final Map<String, CategoryGroup> categoryGroupMap = Map.fromIterable(
      categoryGroupList,
      key: (cat) => cat.id,
      value: (cat) => cat);
}
