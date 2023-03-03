import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:londri/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/admin/admin_home.dart';
import '../pages/user/user_home.dart';

class AuthService {
  Future<void> Register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.email)
                  .set({
                'email': email,
                'role': 'user',
              }));
    } on FirebaseException catch (_) {}
  }

  route(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "user") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const UserHome()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const AdminHome()),
              (route) => false);
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future login(String email, String password, BuildContext context) async {
    late String role;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        var user = value.user!.email;
        var doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user)
            .get();
        role = doc.get('role');
      });
      route(context);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("email", email);
      pref.setString('role', role);
    } on FirebaseAuthException catch (_) {
      // if (e.code == 'user-not-found') {
      //   Utils.showSnackBar('Akun tidak terdaftar', Colors.red);
      // } else if (e.code == 'wrong-password') {
      //   Utils.showSnackBar('Password salah', Colors.red);
      // }
      Utils.showSnackBar(
          'Email tidak terdaftar atau password salah', Colors.red);
    }
  }

  Future logout() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("email");
    pref.remove('role');
  }
}
