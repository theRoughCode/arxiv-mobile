import 'package:arxiv_mobile/models/article.dart';
import 'package:arxiv_mobile/models/favourites.dart';
import 'package:arxiv_mobile/screens/curated/curated_screen.dart';
import 'package:arxiv_mobile/screens/explore/explore_screen.dart';
import 'package:arxiv_mobile/screens/favourites/favourites_screen.dart';
import 'package:arxiv_mobile/themes/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static final ScrollController _curatedListController = ScrollController();

  static List<Widget> _screens = <Widget>[
    CuratedListScreen(controller: _curatedListController),
    ExploreScreen(),
    Selector<FavouritesModel, List<Article>>(
      selector: (_, model) => model.articles,
      builder: (_, articles, __) => FavouritesScreen(
        articles: articles,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    // Jump to start of list for curated screen
    if (index == 0) {
      _curatedListController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'arXiv Mobile',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (context) => FavouritesModel(),
        child: IndexedStack(
          children: _screens,
          index: _selectedIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('For You'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favourites'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
