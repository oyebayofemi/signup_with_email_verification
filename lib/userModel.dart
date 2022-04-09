import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? username;
  final String? regNO;

  UserModel({this.email, this.uid, this.username, this.regNO});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'regNO': regNO,
      };
}
