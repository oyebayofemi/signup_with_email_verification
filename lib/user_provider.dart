import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:signup_with_email_verification/auth_controller.dart';

class UserProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController authController = AuthController();
  // UserModel? currentData;
  DocumentSnapshot? ds;

  Future getUserData() async {
    // UserModel? userModel;
    // String currentUID = _auth.currentUser!.uid;
    // print(currentUID);
    // String? username;
    // DocumentSnapshot value = await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(_auth.currentUser!.uid)
    //     .get()
    //    ;
    // // print('this email');
    // print(value.get('username'));
    // print(username);
    String? uid = (authController.getCurrentUser!.uid).toString();
    await _firestore.collection('users').doc('$uid').get().then((value) {
      ds = value;
      notifyListeners();
    });
    //print(authController.getCurrentUser!.uid);

    // if (value.exists) {
    //   userModel = UserModel(
    //     email: value.get('email'),
    //     regNO: value.get('regNO'),
    //     uid: value.get('uid'),
    //     username: value.get('username'),
    //   );
    //   currentData = userModel;
    //   notifyListeners();
    // }
  }
}
