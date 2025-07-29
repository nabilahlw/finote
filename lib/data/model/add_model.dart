import 'package:cloud_firestore/cloud_firestore.dart';

class AddData {
  final String? id;
  final String name;
  final double amount;
  final String description;
  final DateTime datetime;
  final int type; // <-- PASTIKAN INI INTEGER!
  final String category;

  AddData({
    this.id,
    required this.name,
    required this.amount,
    required this.description,
    required this.datetime,
    required this.type,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'description': description,
      'datetime': datetime,
      'type': type,
      'category': category,
    };
  }

  factory AddData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddData(
      id: doc.id,
      name: data['name'],
      amount: (data['amount'] as num).toDouble(),
      description: data['description'],
      datetime: (data['datetime'] as Timestamp).toDate(),
      type: data['type'],
      category: data['category'],
    );
  }
}
