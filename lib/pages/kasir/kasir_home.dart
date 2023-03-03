import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:londri/service/auth_service.dart';

import '../../auth/login_page.dart';

class KasirHome extends StatelessWidget {
  const KasirHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasir Home'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService().logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
