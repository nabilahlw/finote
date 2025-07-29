// lib/data/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

 static Future<UserModel> fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
  final data = snapshot.data();
  if (data == null) {
    throw Exception("Snapshot has no data");
  }

  return UserModel(
    id: snapshot.id,
    username: data['username'] ?? '',
    email: data['email'] ?? '',
    password: data['password'] ?? '',
  );
}

}
