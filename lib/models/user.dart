import 'account.dart';

/// User model representing a bank customer
class User {
  final String id;
  final String name;
  final String username;
  final String password;
  final List<Account> _accounts = []; // One user can have many accounts

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  // Getter for accounts
  List<Account> get accounts => List.unmodifiable(_accounts);

  /// Add an account to the user
  void addAccount(Account account) {
    _accounts.add(account);
  }

  /// Get account by account number
  Account? getAccount(String accountNumber) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accountNumber);
    } catch (e) {
      return null;
    }
  }

  /// Get user information
  void printUserInfo() {
    print('User ID: $id');
    print('Name: $name');
    print('Username: $username');
    print('Total Accounts: ${_accounts.length}');
  }
}
