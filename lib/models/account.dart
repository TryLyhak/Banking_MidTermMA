import 'transaction.dart';

/// Account model representing a user's bank account
class Account {
  final String accountNumber;
  final String userId;
  double _balance; // private balance
  final List<Transaction> _history = []; // private transaction history

  Account({
    required this.accountNumber,
    required this.userId,
    required double initialBalance,
  }) : _balance = initialBalance;

  // Getter for balance
  double get balance => _balance;

  // Getter for transaction history
  List<Transaction> get history => List.unmodifiable(_history);

  /// Add a transaction to the account
  void addTransaction(Transaction transaction) {
    _history.add(transaction);
  }

  /// Update balance (used by services)
  void updateBalance(double amount) {
    _balance += amount;
  }

  /// Get account details
  void printAccountDetails() {
    print('Account Number: $accountNumber');
    print('User ID: $userId');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
    print('Total Transactions: ${_history.length}');
  }

  /// Get transaction history
  void printTransactionHistory() {
    if (_history.isEmpty) {
      print('No transactions found.');
      return;
    }
    print('\n=== Transaction History ===');
    for (var transaction in _history) {
      print(transaction);
    }
  }
}
