import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/model/transaction_model.dart';

class TransactionRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userTransactions(String uid) =>
    _firestore.collection('users').doc(uid).collection('form_money');

  Future<void> createTransaction(TransactionModel tx, dynamic authRepo) async {
    final uid = authRepo.instance.currentUser?.uid;
    if (uid == null) throw Exception('User tidak terautentikasi');
    await _userTransactions(uid).add(tx.toJson());
  }

  Future<List<TransactionModel>> fetchTransactions(dynamic authRepo) async {
    final uid = authRepo.instance.currentUser?.uid;
    if (uid == null) return [];
    final snapshot = await _userTransactions(uid).orderBy('datetime', descending: true).get();
    return snapshot.docs.map((d) => 
      TransactionModel.fromJson(d.id, d.data())).toList();
  }

  Future<void> updateTransaction(String docId, TransactionModel tx, dynamic authRepo) async {
    final uid = authRepo.instance.currentUser?.uid;
    if (uid == null) throw Exception('User tidak login');
    await _userTransactions(uid).doc(docId).update(tx.toJson());
  }

  Future<void> deleteTransaction(String docId, dynamic authRepo) async {
    final uid = authRepo.instance.currentUser?.uid;
    if (uid == null) throw Exception('User tidak login');
    await _userTransactions(uid).doc(docId).delete();
  }
}
