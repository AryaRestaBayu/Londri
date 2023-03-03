import 'package:flutter/material.dart';
import 'package:londri/auth/login_page.dart';
import 'package:londri/service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

TextEditingController emailC = TextEditingController();
TextEditingController passwordC = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
      ),
      body: Center(
        child: Column(
          children: [
            //email
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                hintText: 'email',
              ),
            ),
            //password
            TextField(
              controller: passwordC,
              decoration: const InputDecoration(
                hintText: 'password',
              ),
            ),
            //button register
            ElevatedButton(
              onPressed: () {
                AuthService()
                    .Register(emailC.text.trim(), passwordC.text.trim());

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
              child: const Text('Daftar'),
            )
          ],
        ),
      ),
    );
  }
}
