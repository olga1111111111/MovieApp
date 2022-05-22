import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';

import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListRowData {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String? posterPath;

  MovieListRowData(
      {required this.id,
      required this.title,
      required this.overview,
      required this.releaseDate,
      required this.posterPath});
}

class MovieListViewModel extends ChangeNotifier {
  final _apiClient = MovieApiClient();
  Timer? searchDebounce;
  String _locale = '';
  final _movies = <MovieListRowData>[];
  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late int _totalPage;
  var _isLoadingInProgress = false;
  late int _currentPage;
  String? _searchQuery;
  late DateFormat _dateFormat;

// запрос с задержкой таймера для отмены побуквенного запроса:

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : "";

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    await _resetList();
  }

  // при поисковом запросе:
  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await _loadNextPage();
  }

  Future<PopularMovieResponse> _loadMovies(
    int nextPage,
    String locale,
  ) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularMovie(nextPage, _locale);
    } else {
      return await _apiClient.searchMovie(nextPage, locale, query);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final movieResponse = await _loadMovies(nextPage, _locale);
      _movies.addAll(movieResponse.movies.map(_makeRowData).toList());
      _currentPage = movieResponse.page;
      _totalPage = movieResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      releaseDate: releaseDateTitle,
      posterPath: movie.posterPath,
    );
  }

  void onMovieTab(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
