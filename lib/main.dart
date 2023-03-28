import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:londri/auth/login_page.dart';
import 'package:londri/pages/admin/admin_navbar.dart';
import 'package:londri/pages/kasir/kasir_home.dart';
import 'package:londri/pages/owner/owner_home.dart';
import 'package:londri/pages/user/user_home.dart';
import 'package:londri/splash.dart';
import 'package:londri/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  var role = prefs.getString("role");
  print(email);
  print(role);
  runApp(MaterialApp(
    //import londri/utils
    scaffoldMessengerKey: Utils.messengerKey,
    debugShowCheckedModeBanner: false,
    home: email == null
        ? const LoginPage()
        : role == 'kasir'
            ? const KasirHome()
            : role == 'admin'
                ? const AdminNavbar()
                : role == 'owner'
                    ? const OwnerHome()
                    : const UserHome(),
  ));
}
