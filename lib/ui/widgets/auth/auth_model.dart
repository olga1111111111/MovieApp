import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';

import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

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

    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          _errorMessage =
              "Сервер недоступен. Проверьте подключение к интернету.";
          break;
        case ApiClientExceptionType.auth:
          _errorMessage = "Неправильный логин или пароль!";
          break;
        case ApiClientExceptionType.other:
          _errorMessage = "Произошла ошибка. Попробуйте еще раз!";
          break;

        case ApiClientExceptionType.sessionExpired:
      }
    } catch (e) {
      _errorMessage = "неизвестная ошибка, повторите попытку";
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }

    // сохранить перед навигацией sessionId:
    // await _sessionDataProvider.setSessionId(sessionId);
    // await _sessionDataProvider.setAccountId(accountId);
    MainNavigation.resetNavigation(context);
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
