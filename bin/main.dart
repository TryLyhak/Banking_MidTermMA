import 'dart:io';
import 'package:banking_midterm/models/user.dart';
import 'package:banking_midterm/models/account.dart';
import 'package:banking_midterm/services/auth_service.dart';
import 'package:banking_midterm/services/account_service.dart';

final AuthService authService = AuthService();
final AccountService accountService = AccountService();
User? currentUser;

void main() {
  print('╔════════════════════════════════════════╗');
  print('║      WELCOME TO BANKING SYSTEM         ║');
  print('╚════════════════════════════════════════╝\n');

  bool running = true;
  while (running) {
    if (currentUser == null) {
      _showAuthMenu();
    } else {
      _showMainMenu();
    }
  }
}

void _showAuthMenu() {
  print('\n━━━ AUTHENTICATION MENU ━━━');
  print('1. Login');
  print('2. Exit');
  // print('Predefined Users:');
  // print('  • Username: john  | Password: password123');
  // print('  • Username: jane  | Password: password123');
  // print('  • Username: bob   | Password: password123');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Choose an option: ');

  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      _login();
      break;
    case '2':
      print('Thank you for using Banking System. Goodbye!');
      exit(0);
    default:
      print('❌ Invalid choice. Please try again.');
  }
}

void _showMainMenu() {
  print('\n━━━ MAIN MENU ━━━');
  print('Welcome, ${currentUser!.name}!');
  print('1. Create Account');
  print('2. View Accounts');
  print('3. Select Account & Deposit');
  print('4. Select Account & Withdraw');
  print('5. Transfer Money');
  print('6. Check Balance');
  print('7. View Transaction History');
  print('8. Search Account by Number');
  print('9. Logout');
  print('━━━━━━━━━━━━━━━');
  print('Choose an option: ');

  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      _createAccount();
      break;
    case '2':
      _viewAccounts();
      break;
    case '3':
      _deposit();
      break;
    case '4':
      _withdraw();
      break;
    case '5':
      _transfer();
      break;
    case '6':
      _checkBalance();
      break;
    case '7':
      _viewTransactionHistory();
      break;
    case '8':
      _searchAccount();
      break;
    case '9':
      _logout();
      break;
    default:
      print('❌ Invalid choice. Please try again.');
  }
}

void _login() {
  print('\n━━━ LOGIN ━━━');
  authService.resetLoginAttempts();
  print('Enter Username: ');
  final username = stdin.readLineSync() ?? '';

  print('Enter Password: ');
  final password = stdin.readLineSync() ?? '';

  currentUser = authService.login(username, password);
}

void _createAccount() {
  print('\n━━━ CREATE ACCOUNT ━━━');
  print('Enter Initial Balance: \$');
  final balanceStr = stdin.readLineSync() ?? '0';
  final balance = double.tryParse(balanceStr) ?? 0.0;

  if (balance < 0) {
    print('❌ Initial balance cannot be negative!');
    return;
  }

  accountService.createAccount(currentUser!, balance);
}

void _viewAccounts() {
  print('\n━━━ YOUR ACCOUNTS ━━━');
  final accounts = currentUser!.accounts;

  if (accounts.isEmpty) {
    print('❌ You have no accounts yet.');
    return;
  }

  for (int i = 0; i < accounts.length; i++) {
    print('\n📊 Account ${i + 1}:');
    accounts[i].printAccountDetails();
  }
}

void _deposit() {
  print('\n━━━ DEPOSIT ━━━');
  final account = _selectAccount();
  if (account == null) return;

  print('Enter Deposit Amount: \$');
  final amountStr = stdin.readLineSync() ?? '0';
  final amount = double.tryParse(amountStr) ?? 0.0;

  accountService.deposit(account, amount);
}

void _withdraw() {
  print('\n━━━ WITHDRAW ━━━');
  final account = _selectAccount();
  if (account == null) return;

  print('Enter Withdrawal Amount: \$');
  final amountStr = stdin.readLineSync() ?? '0';
  final amount = double.tryParse(amountStr) ?? 0.0;

  accountService.withdraw(account, amount);
}

void _transfer() {
  print('\n━━━ TRANSFER ━━━');
  print('Select Source Account:');
  final fromAccount = _selectAccount();
  if (fromAccount == null) return;

  print('\nEnter Destination Account Number: ');
  final toAccountNumber = stdin.readLineSync() ?? '';
  final toAccount = currentUser!.getAccount(toAccountNumber);

  if (toAccount == null) {
    print('❌ Destination account not found!');
    return;
  }

  print('Enter Transfer Amount: \$');
  final amountStr = stdin.readLineSync() ?? '0';
  final amount = double.tryParse(amountStr) ?? 0.0;

  accountService.transfer(fromAccount, toAccount, amount);
}

void _checkBalance() {
  print('\n━━━ CHECK BALANCE ━━━');
  final account = _selectAccount();
  if (account == null) return;

  accountService.checkBalance(account);
}

void _viewTransactionHistory() {
  print('\n━━━ TRANSACTION HISTORY ━━━');
  final account = _selectAccount();
  if (account == null) return;

  accountService.showTransactions(account);
}

void _searchAccount() {
  print('\n━━━ SEARCH ACCOUNT ━━━');
  print('Enter Account Number: ');
  final accountNumber = stdin.readLineSync() ?? '';

  final account = accountService.searchAccountByNumber(
    currentUser!.accounts,
    accountNumber,
  );

  if (account != null) {
    print('✓ Account found!');
    account.printAccountDetails();
  }
}

void _logout() {
  print('Logged out successfully. Thank you!');
  currentUser = null;
  authService.resetLoginAttempts();
}

Account? _selectAccount() {
  final accounts = currentUser!.accounts;

  if (accounts.isEmpty) {
    print('❌ You have no accounts yet.');
    return null;
  }

  print('\nYour Accounts:');
  for (int i = 0; i < accounts.length; i++) {
    print(
      '${i + 1}. ${accounts[i].accountNumber} - \$${accounts[i].balance.toStringAsFixed(2)}',
    );
  }

  print('Select Account (1-${accounts.length}): ');
  final choiceStr = stdin.readLineSync() ?? '0';
  final choice = int.tryParse(choiceStr) ?? 0;

  if (choice < 1 || choice > accounts.length) {
    print('❌ Invalid selection!');
    return null;
  }

  return accounts[choice - 1];
}
