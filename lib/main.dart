import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:londri/auth/login_page.dart';
import 'package:londri/pages/admin/admin_home.dart';
import 'package:londri/pages/kasir/kasir_home.dart';
import 'package:londri/pages/user/user_home.dart';
import 'package:londri/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  var role = prefs.getString("role");

  runApp(MaterialApp(
    scaffoldMessengerKey: Utils.messengerKey,
    debugShowCheckedModeBanner: false,
    home: email == null
        ? const LoginPage()
        : role == 'kasir'
            ? const KasirHome()
            : role == 'admin'
                ? const AdminHome()
                : const UserHome(),
  ));
}
