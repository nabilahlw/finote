import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/model/add_model.dart';

class FormMoneyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _userTxns {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('form_money');
  }

  Future<void> addTransaction(AddData data) {
    return _userTxns.add(data.toJson());
  }

  Future<void> updateTransaction(AddData data) {
    return _userTxns.doc(data.id).update(data.toJson());
  }

  Future<void> deleteTransaction(String id) {
    return _userTxns.doc(id).delete();
  }

  Stream<List<AddData>> streamTransactions() {
    return _userTxns.orderBy('datetime', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => AddData.fromFirestore(d)).toList());
  }
}
