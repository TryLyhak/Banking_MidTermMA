import '../models/user.dart';

/// AuthService handles user authentication with static users
class AuthService {
  final List<User> _users = _initializeStaticUsers();
  int _loginAttempts = 0;
  static const int _maxLoginAttempts = 3;

  /// Initialize static users for the system
  static List<User> _initializeStaticUsers() {
    return [
      User(
        id: 'U001',
        name: 'John Doe',
        username: 'john',
        password: 'password123',
      ),
      User(
        id: 'U002',
        name: 'Jane Smith',
        username: 'jane',
        password: 'password123',
      ),
      User(
        id: 'U003',
        name: 'Bob Johnson',
        username: 'bob',
        password: 'password123',
      ),
    ];
  }

  /// Login a user with attempt limit (max 3 tries)
  User? login(String username, String password) {
    if (_loginAttempts >= _maxLoginAttempts) {
      print(
        '❌ Maximum login attempts ($_maxLoginAttempts) exceeded. Please try again later.',
      );
      return null;
    }

    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      print('✓ Login successful! Welcome, ${user.name}');
      _loginAttempts = 0; // Reset attempts on successful login
      return user;
    } catch (e) {
      _loginAttempts++;
      final attemptsLeft = _maxLoginAttempts - _loginAttempts;
      print('❌ Invalid username or password!');
      print('   Attempts left: $attemptsLeft');
      return null;
    }
  }

  /// Reset login attempts (for session reset)
  void resetLoginAttempts() {
    _loginAttempts = 0;
  }

  /// Get user by username
  User? getUserByUsername(String username) {
    try {
      return _users.firstWhere((u) => u.username == username);
    } catch (e) {
      return null;
    }
  }

  /// Get all users (for debugging/info)
  List<User> getAllUsers() => List.unmodifiable(_users);
}
