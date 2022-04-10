import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class LoaderViewModel {
  final BuildContext context;
  final _authService = AuthService();

  LoaderViewModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final isAuth = await _authService.isAuth();
    final nextScreen = isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);

    // if ( isAuth) {
    //   Navigator.of(context)
    //       .pushReplacementNamed(MainNavigationRouteNames.mainScreen);
    // } else {
    //   Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth);
    // }
  }
}
