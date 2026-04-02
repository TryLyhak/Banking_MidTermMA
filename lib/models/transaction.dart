/// Transaction model representing a single banking transaction
class Transaction {
  final String id;
  final String type; // 'Deposit', 'Withdraw', 'TransferIn', 'TransferOut'
  final double amount;
  final DateTime createdAt;
  final String description;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.description,
  });

  @override
  String toString() {
    return '$type | \$${amount.toStringAsFixed(2)} | $description | ${createdAt.toString()}';
  }
}
