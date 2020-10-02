import 'package:arxiv_mobile/models/downloads.dart';
import 'package:arxiv_mobile/models/favourites.dart';
import 'package:arxiv_mobile/services/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'screens/navigation/navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize DB
  DatabaseManager();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavouritesModel()),
        ChangeNotifierProvider(create: (context) => DownloadsModel()),
      ],
      child: MaterialApp(
        title: 'arXiv Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
        ),
        home: NavigationHomeScreen(),
      ),
    );
  }
}
