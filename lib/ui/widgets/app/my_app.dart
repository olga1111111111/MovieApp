import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDardBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainDardBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''),
        Locale('en', ''),
      ],
      routes: mainNavigation.routes,
      initialRoute: MainNavigationRouteNames.loaderWidget,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
