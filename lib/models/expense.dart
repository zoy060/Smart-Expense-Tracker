class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Convert Expense object to Map.
  // Useful later if you want to save data in Firebase,
  // SQLite, or another database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Create an Expense object from Map.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  String toString() {
    return 'Expense('
        'id: $id, '
        'title: $title, '
        'amount: $amount, '
        'category: $category, '
        'date: $date'
        ')';
  }
}