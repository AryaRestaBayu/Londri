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
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var email = prefs.getString("email");
  // var role = prefs.getString("role");
  runApp(MaterialApp(
      //import londri/utils
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      home: const Splash()
      // email == null
      //     ? const LoginPage()
      //     : role == 'kasir'
      //         ? const KasirHome()
      //         : role == 'admin'
      //             ? const AdminNavbar()
      //             : role == 'owner'
      //                 ? const OwnerHome()
      //                 : const UserHome(),
      ));
}

class RoleTree extends StatefulWidget {
  const RoleTree({super.key});

  @override
  State<RoleTree> createState() => _RoleTreeState();
}

class _RoleTreeState extends State<RoleTree> {
  @override
  void initState() {
    getPref();
    super.initState();
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email");
    role = prefs.getString("role");
  }

  String? email;
  String? role;

  @override
  Widget build(BuildContext context) {
    return email == null
        ? const LoginPage()
        : role == 'kasir'
            ? const KasirHome()
            : role == 'admin'
                ? const AdminNavbar()
                : role == 'owner'
                    ? const OwnerHome()
                    : const UserHome();
  }
}
