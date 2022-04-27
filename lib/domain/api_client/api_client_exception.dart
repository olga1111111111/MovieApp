/// ошибки
/// 1) нет сети
/// 2) нет ответа от сервера, таймаут соединения
/// 3) сервер недоступен
/// 4) сервер не может обработать запрос
/// 5) сервер ответил не то,что ожидали
/// 6) сервер ответил ожидаемой ошибкой /

enum ApiClientExceptionType { network, auth, other, sessionExpired }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}
