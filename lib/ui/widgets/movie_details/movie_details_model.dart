import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

import '../../../domain/api_client/account_api_client.dart';
import '../../../domain/api_client/api_client_exception.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _movieApiClient = MovieApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = "";
  bool _isFavorite = false;
  late DateFormat _dateFormat;
  Future<void>? Function()? onSessionExpired;

  MovieDetailsModel(this.movieId);

  MovieDetails? get movieDetails => _movieDetails;
  bool get isFavorite => _isFavorite;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : "";

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      _movieDetails = await _movieApiClient.movieDetails(_locale, movieId);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _movieApiClient.isFavorite(sessionId, movieId);
      }

      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientExeption(e);
    }
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    _isFavorite = !_isFavorite;
    notifyListeners();
    try {
      await _accountApiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.movie,
        mediaId: movieId,
        isFavorite: _isFavorite,
      );
    } on ApiClientException catch (_) {
      // выбивает из приложения при status code 3:
      // _handleApiClientExeption(e);
    }
  }

  void _handleApiClientExeption(ApiClientException exception) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        onSessionExpired?.call();
        break;
      default:
        print(exception);
    }
  }
}
