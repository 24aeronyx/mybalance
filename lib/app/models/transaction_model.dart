class Transaction {
  final String title;
  final String category; 
  final String transactionType; 
  final DateTime date;
  final double amount;

  Transaction({
    required this.title,
    required this.category,
    required this.transactionType,
    required this.date,
    required this.amount,
  });
}
