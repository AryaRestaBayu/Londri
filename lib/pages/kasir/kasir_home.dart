import 'package:flutter/material.dart';
import 'package:londri/service/auth_service.dart';

import '../../auth/login_page.dart';

class KasirHome extends StatelessWidget {
  const KasirHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Home'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService().logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
