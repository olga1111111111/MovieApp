import '../data_providers/session_data_provider.dart';

class AuthService {
  Future<bool> isAuth() async {
    final _sessionDataProvider = SessionDataProvider();
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }
}
