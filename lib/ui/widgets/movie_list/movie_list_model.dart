import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';

import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);
  final _dateFormat = DateFormat.yMMMd();

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : "";

  Future<void> loadMovies() async {
    final movieResponse = await _apiClient.popularMovie(1, 'ru-RU');
    _movies.addAll(movieResponse.movie);
    notifyListeners();
  }

  void onMovieTab(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }
}
