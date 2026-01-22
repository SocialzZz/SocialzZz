class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  String? _accessToken;
  String? _userId;

  String? get accessToken => _accessToken;
  String? get userId => _userId;

  void setToken(String token) {
    _accessToken = token;
  }

  void setUserId(String id) {
    _userId = id;
  }

  void clear() {
    _accessToken = null;
    _userId = null;
  }

  bool get isLoggedIn => _accessToken != null;
}
