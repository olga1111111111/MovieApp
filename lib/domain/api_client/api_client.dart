import 'dart:io';
import 'dart:convert';

/// ошибки
/// 1) нет сети
/// 2) нет ответа от сервера, таймаут соединения
/// 3) сервер недоступен
/// 4) сервер не может обработать запрос
/// 5) сервер ответил не то,что ожидали
/// 6) сервер ответил ожидаемой ошибкой /

enum ApiClientExceptionType { Network, Auth, Other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '744d0b824522a8e452d1272a1a9b2d76';

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parametrs]) {
    final uri = Uri.parse('$_host$path');
    if (parametrs != null) {
      return uri.replace(queryParameters: parametrs);
    } else {
      return uri;
    }
  }

  Future<String> _makeToken() async {
    final url = _makeUri(
      '/authentication/token/new',
      {'api_key': _apiKey},
    );
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;
      if (response.statusCode == 401) {
        final status = json["status_code"];
        final code = status is int ? status : 0;
        if (code == 30) {
          throw ApiClientException(ApiClientExceptionType.Auth);
        } else {
          throw ApiClientException(ApiClientExceptionType.Other);
        }
      }
      final token = json['request_token'] as String;
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    try {
      final url = _makeUri(
        '/authentication/token/validate_with_login',
        {'api_key': _apiKey},
      );
      final parametrs = <String, dynamic>{
        'username': username,
        'password': password,
        'request_token': requestToken,
      };
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parametrs));
      final response = await request.close();
      final json = (await response.jsonDecode()) as Map<String, dynamic>;
      if (response.statusCode == 401) {
        final status = json["status_code"];
        final code = status is int ? status : 0;
        if (code == 30) {
          throw ApiClientException(ApiClientExceptionType.Auth);
        } else {
          throw ApiClientException(ApiClientExceptionType.Other);
        }
      }

      final token = json['request_token'] as String;
      return token;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }

  Future<String> _makeSession({
    required String requestToken,
  }) async {
    try {
      final url = _makeUri(
        '/authentication/session/new',
        {'api_key': _apiKey},
      );
      final parametrs = <String, dynamic>{
        'request_token': requestToken,
      };
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parametrs));
      final response = await request.close();

      final json = (await response.jsonDecode()) as Map<String, dynamic>;
      if (response.statusCode == 401) {
        final status = json["status_code"];
        final code = status is int ? status : 0;
        if (code == 30) {
          throw ApiClientException(ApiClientExceptionType.Auth);
        } else {
          throw ApiClientException(ApiClientExceptionType.Other);
        }
      }
      final sessionId = json['session_id'] as String;
      return sessionId;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.Network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.Other);
    }
  }
}

extension HttpClientResponsJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder).toList().then((value) {
      final result = value.join();
      return result;
    }).then((v) => json.decode(v));
  }
}
