class WeeklyData {
  int week;
  double income;
  double outcome;

  WeeklyData({
    required this.week,
    required this.income,
    required this.outcome,
  });

  // Method untuk membuat WeeklyData dari map (untuk parsing data dari API)
  factory WeeklyData.fromMap(Map<String, dynamic> map) {
    return WeeklyData(
      week: map['week'] ?? 0,
      income: map['income'] ?? 0,
      outcome: map['outcome'] ?? 0,
    );
  }

  // Method untuk mengkonversi WeeklyData menjadi map (untuk penggunaan lainnya)
  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'income': income,
      'outcome': outcome,
    };
  }
}
