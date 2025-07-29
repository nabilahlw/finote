class TransactionModel {
  final String id;
  final String name;
  final double amount;
  final String category;
  final int type; // 1=Income, 0=Expense
  final DateTime datetime;
  final String description;

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.type,
    required this.datetime,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'category': category,
    'type': type,
    'datetime': datetime.toIso8601String(),
    'description': description,
  };

  static TransactionModel fromJson(String id, Map<String, dynamic> json) {
    return TransactionModel(
      id: id,
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      type: json['type'],
      datetime: DateTime.parse(json['datetime']),
      description: json['description'] ?? '',
    );
  }
}
