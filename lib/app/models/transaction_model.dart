class Transaction {
  final String title;
  final String category;
  final String type;
  final DateTime date;
  final double amount;

  Transaction({
    required this.title,
    required this.category,
    required this.type,
    required this.date,
    required this.amount,
  });

  @override
  String toString() {
    return 'Transaction(title: $title, category: $category, type: $type, date: $date, amount: $amount)';
  }
}
