import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get idUser => FirebaseAuth.instance.currentUser!.uid;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('Users').doc(idUser).set(user.toJson());

      Get.snackbar(
        'Success',
        'Your account has been created',
        snackPosition: SnackPosition.BOTTOM,
        // ignore: deprecated_member_use
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong, try again',
        snackPosition: SnackPosition.BOTTOM,
        // ignore: deprecated_member_use
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      debugPrint(e.toString());
    }
  }

  Future<UserModel> getUserDetails(String uid) async {
  final snapshot = await _db.collection("users").doc(uid).get();
  return UserModel.fromSnapshot(snapshot); // tidak perlu await kalau tidak async
}


  Future<void> updateUser(UserModel user) async {
    await _db.collection('Users').doc(idUser).update(user.toJson());
  }

  Future<void> deleteUser(String idUser) async {
    await _db.collection('Users').doc(idUser).delete();
  }
}
