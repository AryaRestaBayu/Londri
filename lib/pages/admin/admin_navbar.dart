import 'package:flutter/material.dart';
import 'package:londri/pages/admin/admin_home.dart';
import 'package:londri/pages/admin/outlet/list_outlet.dart';
import 'package:londri/pages/admin/user/list_user.dart';

class AdminNavbar extends StatefulWidget {
  const AdminNavbar({super.key});

  @override
  State<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
  int selectedIndex = 0;
  List pages = const [AdminHome(), ListUser(), ListOutlet()];

  void selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF67bde1),
          currentIndex: selectedIndex,
          onTap: selectPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          ]),
    );
  }
}
