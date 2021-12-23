import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;

  Future<void> auth(BuildContext context) async {}
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
