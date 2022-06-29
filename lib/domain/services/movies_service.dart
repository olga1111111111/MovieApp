import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/domain/local_entity/movie_details_local.dart';

import '../api_client/account_api_client.dart';
import '../data_providers/session_data_provider.dart';

class MoviesService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(
        page,
        locale,
        Configuration.apiKey,
      );

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async =>
      _movieApiClient.searchMovie(
        page,
        locale,
        query,
        Configuration.apiKey,
      );

  Future<MovieDetailsLocal> loadDetails({
    required String locale,
    required int movieId,
  }) async {
    final movieDetails = await _movieApiClient.movieDetails(locale, movieId);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(sessionId, movieId);
    }
    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  // текущее состояние isFavorite:
  Future<void> upDateFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}
