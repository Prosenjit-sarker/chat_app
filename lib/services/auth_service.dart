class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, Map<String, String>> _accounts = {};
  String? _email;
  String? _name;

  String? get currentUserEmail => _email;
  String? get currentUserName => _name;
  bool get isLoggedIn => _email != null;

  List<Map<String, String>> get allAccounts {
    return _accounts.entries.map((entry) => {'email': entry.key, 'name': entry.value['name'] ?? ''}).toList();
  }

  String? getAccountName(String email) {
    return _accounts[email]?['name'];
  }

  List<Map<String, String>> getOtherAccounts(String currentEmail) {
    return allAccounts.where((account) => account['email'] != currentEmail).toList();
  }

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final record = _accounts[email];
    if (record == null) {
      throw Exception('No account found for this email. Please register first.');
    }
    if (record['password'] != password) {
      throw Exception('Incorrect password.');
    }
    _email = email;
    _name = record['name'];
  }

  Future<void> register(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_accounts.containsKey(email)) {
      throw Exception('Account already exists with this email. Please login.');
    }
    _accounts[email] = {'name': name, 'password': password};
    _email = email;
    _name = name;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _email = null;
    _name = null;
  }
}
