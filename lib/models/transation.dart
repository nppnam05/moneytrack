class Transaction {
  final String type; // "Thu" hoặc "Chi"
  final double amount;
  final DateTime date;
  final String category;
  final String note;
  final String userEmail;

  Transaction({
    required this.type,
    required this.amount,
    required this.date,
    required this.category,
    required this.note,
    required this.userEmail,
  });
}