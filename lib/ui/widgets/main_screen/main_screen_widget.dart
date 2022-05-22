import 'package:flutter/material.dart';

import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/factories/screen_factory.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListViewModel();
  final _screenFactory = ScreenFactory();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   movieListModel.setupLocale(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            // временный логаут:
            onPressed: () => SessionDataProvider().setSessionId(null),
          )
        ],
        title: const Text('TMDB'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _screenFactory.makeNewsList(),
          _screenFactory.makeMovieList(),
          _screenFactory.makeTvShowList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'новости'),
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_outlined), label: 'фильмы'),
          BottomNavigationBarItem(
              icon: Icon(Icons.tv_outlined), label: 'сериалы'),
        ],
        onTap: onSelectTab,
      ),
    );
  }
}
