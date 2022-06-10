import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import '../../../domain/api_client/account_api_client.dart';
import '../../../domain/api_client/api_client_exception.dart';

class MovieDetailsData {
  String title = "Загрузка...";
  bool isLoading = true;
}

class MovieDetailsModel extends ChangeNotifier {
  final authService = AuthService();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _movieApiClient = MovieApiClient();

  final int movieId;
  final data = MovieDetailsData();
  MovieDetails? _movieDetails;
  String _locale = "";
  bool _isFavorite = false;
  late DateFormat _dateFormat;
  // Future<void>? Function()? onSessionExpired;

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
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      _movieDetails = await _movieApiClient.movieDetails(_locale, movieId);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _movieApiClient.isFavorite(sessionId, movieId);
      }

      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientExeption(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();

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
        authService.logout();
        MainNavigation.resetNavigation(context);

        break;
      default:
        print(exception);
    }
  }
}
