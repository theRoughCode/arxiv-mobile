import 'package:arxiv_mobile/themes/utils.dart';
import 'package:flutter/material.dart';

class CategoryGroup {
  CategoryGroup({this.id, this.name, this.colour = Colors.grey});

  String id;
  String name;
  Color colour;

  // List of available category groups
  static final List<CategoryGroup> categoryGroupList = <CategoryGroup>[
    CategoryGroup(
        id: "astro-ph", name: "Astrophysics", colour: HexColor("#15378c")),
    CategoryGroup(
        id: "cond-mat", name: "Condensed Matter", colour: HexColor("#10b09b")),
    CategoryGroup(
        id: "cs", name: "Computer Science", colour: HexColor("#0ba3d6")),
    CategoryGroup(id: "econ", name: "Economics", colour: HexColor("#0ed100")),
    CategoryGroup(
        id: "eess",
        name: "Electrical Engineering and Systems Science",
        colour: HexColor("#d17a00")),
    CategoryGroup(
        id: "gr-qc",
        name: "General Relativity and Quantum Cosmology",
        colour: HexColor("#3a0096")),
    CategoryGroup(
        id: "hep", name: "High Energy Physics", colour: HexColor("#6c0096")),
    CategoryGroup(id: "math", name: "Mathematics", colour: HexColor("#990000")),
    CategoryGroup(
        id: "nlin", name: "Nonlinear Sciences", colour: HexColor("#bd0048")),
    CategoryGroup(id: "physics", name: "Physics", colour: HexColor("##0009bd")),
    CategoryGroup(
        id: "q-bio", name: "Quantitative Biology", colour: HexColor("#3fbd00")),
    CategoryGroup(
        id: "q-fin", name: "Quantitative Finance", colour: HexColor("#ba9200")),
    CategoryGroup(
        id: "quant-ph", name: "Quantum Physics", colour: HexColor("#5400ba")),
    CategoryGroup(id: "stat", name: "Statistics", colour: HexColor("#ba0057")),
  ];

  // Construct mapping from category group ID to CategoryGroup
  static final Map<String, CategoryGroup> categoryGroupMap = Map.fromIterable(
      categoryGroupList,
      key: (cat) => cat.id,
      value: (cat) => cat);
}
