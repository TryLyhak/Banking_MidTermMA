import 'dart:math';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/account.dart';
import '../models/transaction.dart';

/// AccountService handles account and transaction operations
class AccountService {
  /// Get all accounts for a specific user
  List<Account> getUserAccounts(String userId) {
    // This would be called with currentUser.accounts
    // Method here for service layer consistency
    return [];
  }

  /// Create a new account for a user
  Account createAccount(User user, double initialBalance) {
    final accountNumber = _generateAccountNumber();
    final account = Account(
      accountNumber: accountNumber,
      userId: user.id,
      initialBalance: initialBalance,
    );
    user.addAccount(account);
    print('✓ Account created successfully!');
    print('Account Number: $accountNumber');
    return account;
  }

  /// Deposit money into an account
  bool deposit(Account account, double amount) {
    if (amount <= 0) {
      print('❌ Deposit amount must be greater than 0!');
      return false;
    }

    account.updateBalance(amount);
    final transaction = Transaction(
      id: _generateTransactionId(),
      type: 'Deposit',
      amount: amount,
      createdAt: DateTime.now(),
      description: 'Deposit to account ${account.accountNumber}',
    );
    account.addTransaction(transaction);
    print('✓ Deposit successful! Amount: \$${amount.toStringAsFixed(2)}');
    print('New Balance: \$${account.balance.toStringAsFixed(2)}');
    return true;
  }

  /// Withdraw money from an account
  bool withdraw(Account account, double amount) {
    if (amount <= 0) {
      print('❌ Withdrawal amount must be greater than 0!');
      return false;
    }

    if (account.balance < amount) {
      print('❌ Insufficient balance!');
      print('Available balance: \$${account.balance.toStringAsFixed(2)}');
      return false;
    }

    account.updateBalance(-amount);
    final transaction = Transaction(
      id: _generateTransactionId(),
      type: 'Withdraw',
      amount: amount,
      createdAt: DateTime.now(),
      description: 'Withdrawal from account ${account.accountNumber}',
    );
    account.addTransaction(transaction);
    print('✓ Withdrawal successful! Amount: \$${amount.toStringAsFixed(2)}');
    print('New Balance: \$${account.balance.toStringAsFixed(2)}');
    return true;
  }

  /// Transfer money between accounts
  bool transfer(Account fromAccount, Account toAccount, double amount) {
    if (amount <= 0) {
      print('❌ Transfer amount must be greater than 0!');
      return false;
    }

    // Check for same account transfer
    if (fromAccount.accountNumber == toAccount.accountNumber) {
      print('❌ Cannot transfer to the same account!');
      return false;
    }

    if (fromAccount.balance < amount) {
      print('❌ Insufficient balance for transfer!');
      return false;
    }

    // Deduct from source account
    fromAccount.updateBalance(-amount);
    final fromTransaction = Transaction(
      id: _generateTransactionId(),
      type: 'TransferOut',
      amount: amount,
      createdAt: DateTime.now(),
      description: 'Transfer to ${toAccount.accountNumber}',
    );
    fromAccount.addTransaction(fromTransaction);

    // Add to destination account
    toAccount.updateBalance(amount);
    final toTransaction = Transaction(
      id: _generateTransactionId(),
      type: 'TransferIn',
      amount: amount,
      createdAt: DateTime.now(),
      description: 'Transfer from ${fromAccount.accountNumber}',
    );
    toAccount.addTransaction(toTransaction);

    print('✓ Transfer successful!');
    print('Transferred: \$${amount.toStringAsFixed(2)}');
    print('From Account Balance: \$${fromAccount.balance.toStringAsFixed(2)}');
    print('To Account Balance: \$${toAccount.balance.toStringAsFixed(2)}');
    return true;
  }

  /// Check balance of an account
  void checkBalance(Account account) {
    print('\n📊 Account Balance');
    print('Account Number: ${account.accountNumber}');
    print('Balance: \$${account.balance.toStringAsFixed(2)}');
  }

  /// Show transaction history of an account
  void showTransactions(Account account) {
    final transactions = account.history;
    if (transactions.isEmpty) {
      print('❌ No transactions found.');
      return;
    }

    print('\n=== Transaction History ===');
    for (var transaction in transactions) {
      final date = DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.createdAt);
      print(
        '${transaction.type.padRight(12)} | \$${transaction.amount.toStringAsFixed(2).padLeft(10)} | $date | ${transaction.description}',
      );
    }
  }

  /// Search account by account number (requires access to all accounts)
  Account? searchAccountByNumber(
    List<Account> allAccounts,
    String accountNumber,
  ) {
    try {
      return allAccounts.firstWhere((acc) => acc.accountNumber == accountNumber);
    } catch (e) {
      print('❌ Account not found!');
      return null;
    }
  }

  /// Generate random account number
  String _generateAccountNumber() {
    const String chars = '0123456789';
    final Random rnd = Random();
    return List.generate(
      10,
      (index) => chars[rnd.nextInt(chars.length)],
    ).join();
  }

  /// Generate random transaction ID
  String _generateTransactionId() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random rnd = Random();
    return List.generate(8, (index) => chars[rnd.nextInt(chars.length)]).join();
  }
}
