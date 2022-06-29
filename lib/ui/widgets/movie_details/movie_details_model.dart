import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/domain/services/movies_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import '../../../domain/api_client/api_client_exception.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;
  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_border_outlined;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String name;
  final String year;
  MovieDetailsMovieNameData({
    required this.name,
    required this.year,
  });
}

class MovieDetailsMovieScoreData {
  final double voteAverage;
  final String? trailerKey;
  MovieDetailsMovieScoreData({
    required this.voteAverage,
    this.trailerKey,
  });
}

class MovieDetailsMoviePeopleData {
  final String name;
  final String job;
  MovieDetailsMoviePeopleData({
    required this.name,
    required this.job,
  });
}

class MovieDetailsMovieActorData {
  final String name;
  final String character;
  final String? profilePath;
  MovieDetailsMovieActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsData {
  String title = "";
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsMovieNameData nameData =
      MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsMovieScoreData scoreData =
      MovieDetailsMovieScoreData(voteAverage: 0);
  String summary = '';
  List<List<MovieDetailsMoviePeopleData>> peopleData =
      const <List<MovieDetailsMoviePeopleData>>[];
  List<MovieDetailsMovieActorData> actorsData =
      const <MovieDetailsMovieActorData>[];
}

class MovieDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _movieService = MoviesService();

  final int movieId;
  final data = MovieDetailsData();

  String _locale = "";

  late DateFormat _dateFormat;
  // Future<void>? Function()? onSessionExpired;

  MovieDetailsModel(this.movieId);

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    final localeTag = locale.toLanguageTag();
    if (_locale == localeTag) return;
    _locale = localeTag;
    _dateFormat = DateFormat.yMMMMd(localeTag);
    //если локаль обновится почистить  все данные и загрузить новые
    updateData(null, false);
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details =
          await _movieService.loadDetails(locale: _locale, movieId: movieId);

      updateData(details.details, details.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientExeption(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? "Загрузка...";
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? "";

    data.posterData = MovieDetailsPosterData(
        backdropPath: details.backdropPath,
        posterPath: details.posterPath,
        isFavorite: isFavorite);
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.nameData = MovieDetailsMovieNameData(name: details.title, year: year);
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.scoreData = MovieDetailsMovieScoreData(
        voteAverage: details.voteAverage * 10, trailerKey: trailerKey);
    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);
    data.actorsData = details.credits.cast
        .map((e) => MovieDetailsMovieActorData(
            name: e.name, character: e.character, profilePath: e.profilePath))
        .toList();
    notifyListeners();
  }

  List<List<MovieDetailsMoviePeopleData>> makePeopleData(MovieDetails details) {
    var crew = details.credits.crew
        .map((e) => MovieDetailsMoviePeopleData(name: e.name, job: e.job))
        .toList();

    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<MovieDetailsMoviePeopleData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return crewChunks;
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];
    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }

    if (details.productionCountries.isNotEmpty) {
      texts.add('(${details.productionCountries.first.iso})');
    }

    if (details.genres.isNotEmpty) {
      var genersNames = <String>[];
      for (var genr in details.genres) {
        genersNames.add(genr.name);
      }
      texts.add(genersNames.join(', '));
    }
    final runtime = details.runtime ?? 0;
    // final milliseconds = runtime * 60000;
    // final runtimeDate =
    //     DateTime.fromMillisecondsSinceEpoch(milliseconds).toUtc();
    // texts.add(DateFormat.Hm().format(runtimeDate));
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h  ${minutes}m');
    return texts.join(' ');
  }

  Future<void> toggleFavorite(BuildContext context) async {
//переключение состояния
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();
    try {
      await _movieService.upDateFavorite(
          movieId: movieId, isFavorite: data.posterData.isFavorite);
    } on ApiClientException catch (_) {
      // выбивает из приложения при нажатии на избранное status code 3:
      // _handleApiClientExeption(e);
      // _handleApiClientExeption(e, context);
    }
  }

  void _handleApiClientExeption(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        // onSessionExpired?.call();
        _authService.logout();
        MainNavigation.resetNavigation(context);

        break;
      default:
        print(exception);
    }
  }
}
