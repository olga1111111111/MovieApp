import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  // static final List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'домой',
  //   ),
  //   // Text("reerr"),
  //   MovieListWidget(),
  //   Text(
  //     'сериалы',
  //   ),
  // ];

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          MovieListWidget(),
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
