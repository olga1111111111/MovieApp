import 'package:flutter/material.dart';
import 'package:themoviedb/Labrary/Widgets/inherited/provider.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    super.initState();
    movieListModel.loadMovies();
  }

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
        title: Text('TMDB'),
      ),
      body: IndexedStack(
        // child: _widgetOptions.elementAt(_selectedTab),
        index: _selectedTab,
        children: [
          Text(
            'новости',
          ),
          // Text("reerr"),
          NotifierProvider(
            model: movieListModel,
            child: const MovieListWidget(),
          ),
          Text(
            'сериалы',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
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
