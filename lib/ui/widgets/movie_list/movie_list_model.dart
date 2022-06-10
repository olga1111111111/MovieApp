import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/Labrary/Widgets/inherited/paginator.dart';

import 'package:themoviedb/domain/entity/movie.dart';

import 'package:themoviedb/domain/services/movies_service.dart';

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
  final _movieService = MoviesService();
  //пагинатор хранит прогресс загруженных страниц и загружает следующую
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  // запрос с задержкой таймера для отмены побуквенного запроса:
  Timer? searchDebounce;
  String _locale = '';
  var _movies = <MovieListRowData>[];
  String? _searchQuery;
  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  List<MovieListRowData> get movies => List.unmodifiable(_movies);

  late DateFormat _dateFormat;
  MovieListViewModel() {
    _popularMoviePaginator = Paginator<Movie>((page) async {
      final result = await _movieService.popularMovie(page, _locale);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await _movieService.searchMovie(page, _locale, _searchQuery ?? '');
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    await _resetList();
  }

  // при поисковом запросе:
  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
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
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
/*
1) сторока поиска пустая
2) строка поиска заполнена - гружу следующую страницу
3) строка поиска заполнена, но текст там другой, гружу первую страницу
*/
