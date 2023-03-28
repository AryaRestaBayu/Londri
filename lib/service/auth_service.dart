import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:londri/auth/login_page.dart' as Login;
import 'package:londri/auth/register_page.dart' as register;
import 'package:londri/pages/admin/admin_navbar.dart';
import 'package:londri/pages/kasir/kasir_home.dart';
import 'package:londri/pages/owner/owner_home.dart';
import 'package:londri/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/user/user_home.dart';

class AuthService {
  Future<void> Register(
      BuildContext context, String email, String password) async {
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
      route(context);
    } on FirebaseException catch (_) {
      Utils.showSnackBar(
          'Email tidak valid atau email telah terdaftar', Colors.red);
    }
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
        } else if (documentSnapshot.get('role') == "kasir") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const KasirHome()),
              (route) => false);
        } else if (documentSnapshot.get('role') == "owner") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const OwnerHome()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const AdminNavbar()),
              (route) => false);
        }
        register.emailC.text = '';
        register.passwordC.text = '';
        register.confirmPasswordC.text = '';
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
      Login.emailC.text = '';
      Login.passwordC.text = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showSnackBar('Email tidak terdaftar', Colors.red);
      } else if (e.code == 'wrong-password') {
        Utils.showSnackBar('Password salah', Colors.red);
      } else {
        Utils.showSnackBar('Email tidak valid', Colors.red);
      }
    }
  }

  Future logout() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("email");
    pref.remove('role');
  }
}
