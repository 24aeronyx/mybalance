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

  // Method untuk membuat instance dari JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'] as String,
      category: json['category'] as String,
      transactionType: json['transactionType'] as String,
      date: DateTime.parse(json['date'] as String), // Pastikan format tanggal sesuai ISO-8601
      amount: (json['amount'] as num).toDouble(),
    );
  }

  // Method untuk mengubah instance menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'transactionType': transactionType,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }
}
