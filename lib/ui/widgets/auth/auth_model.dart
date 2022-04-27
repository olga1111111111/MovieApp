import 'package:flutter/material.dart';

import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import '../../../domain/api_client/api_client_exception.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty || password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          // _errorMessage =
          return "Сервер недоступен. Проверьте подключение к интернету.";
        // break;
        case ApiClientExceptionType.auth:
          return "Неправильный логин или пароль!";

        case ApiClientExceptionType.other:
          return "Произошла ошибка. Попробуйте еще раз!";

        case ApiClientExceptionType.sessionExpired:
      }
    } catch (e) {
      return "неизвестная ошибка, повторите попытку";
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      _updateState("заполните логин и пароль", false);

      return;
    }
    _updateState(null, true);

    _errorMessage = await _login(login, password);
    if (_errorMessage == null) {
      MainNavigation.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }

    // сохранить перед навигацией sessionId:
    // await _sessionDataProvider.setSessionId(sessionId);
    // await _sessionDataProvider.setAccountId(accountId);
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
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
