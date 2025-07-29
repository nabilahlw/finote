import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/model/add_model.dart';

class FirebaseDataService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _transCollection {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return _firestore.collection('users').doc(uid).collection('form_money');
  }
  Future<void> createUser(User user, String username) async {
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'email': user.email,
    'username': username,
    'created_at': FieldValue.serverTimestamp(),
  });
}

  Future<void> addData(AddData data) async {
    await _transCollection.add(data.toJson());
  }

  Future<void> updateData(String docId, AddData data) async {
    await _transCollection.doc(docId).update(data.toJson());
  }

  Future<void> deleteData(String docId) async {
    await _transCollection.doc(docId).delete();
  }

  Future<List<AddData>> getAllData() async {
    final snapshot = await _transCollection.orderBy('datetime', descending: true).get();
    return snapshot.docs.map((d) => AddData.fromFirestore(d)).toList();
  }
  Future<String> getUserName() async {
  final user = FirebaseAuth.instance.currentUser;
  final doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
  return doc.data()?['username'] ?? 'Guest';
}

  Stream<List<AddData>> getDataStream() {
  final uid = _auth.currentUser?.uid;
  if (uid == null) return Stream.value([]);
  return _firestore
      .collection('users')
      .doc(uid)
      .collection('form_money')
      .orderBy('datetime', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AddData.fromFirestore(doc))
          .toList());
}

  Future<void> saveUserName(String username) async {}


}
