import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_widget.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
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
    try {
      sessionId = await ApiClient().auth(
        username: login,
        password: password,
      );
    } catch (e) {
      _errorMessage = "неправильный логин или пароль!";
    }
    _isAuthProgress = false;
    if (_errorMessage == null || sessionId == null) {
      notifyListeners();
    }

    // Navigator.of(context).pushNamed('/main_screen');
  }
}

class AuthProvaider extends InheritedNotifier {
  final AuthModel model;
  AuthProvaider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static AuthProvaider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvaider>();
  }

  static AuthProvaider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<AuthProvaider>()
        ?.widget;
    return widget is AuthProvaider ? widget : null;
  }
}
