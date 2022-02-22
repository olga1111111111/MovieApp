import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';

import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (login.isEmpty || password.isEmpty) {
      _errorMessage = "заполните логин и пароль";
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    int? accountId;
    try {
      sessionId = await _apiClient.auth(
        username: login,
        password: password,
      );
      accountId = await _apiClient.getAccountInfo(sessionId);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.Network:
          _errorMessage =
              "Сервер недоступен. Проверьте подключение к интернету.";
          break;
        case ApiClientExceptionType.Auth:
          _errorMessage = "Неправильный логин или пароль!";
          break;
        case ApiClientExceptionType.Other:
          _errorMessage = "Произошла ошибка. Попробуйте еще раз!";
          break;
        default:
          print(e);
      }
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }

    if (sessionId == null || accountId == null) {
      _errorMessage = "неизвестная ошибка, повторите попытку";
      notifyListeners();
      return;
    }
    // сохранить перед навигацией sessionId:
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);
  }
}




// class AuthProvaider extends InheritedNotifier {
//   final AuthModel model;
//   AuthProvaider({
//     Key? key,
//     required this.model,
//     required Widget child,
//   }) : super(
//           key: key,
//           notifier: model,
//           child: child,
//         );

//   static AuthProvaider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvaider>();
//   }

//   static AuthProvaider? read(BuildContext context) {
//     final widget = context
//         .getElementForInheritedWidgetOfExactType<AuthProvaider>()
//         ?.widget;
//     return widget is AuthProvaider ? widget : null;
//   }
// }
