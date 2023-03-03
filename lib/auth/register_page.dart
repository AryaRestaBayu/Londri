import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        title: Text('Daftar'),
      ),
      body: Center(
        child: Column(
          children: [
            //email
            TextField(
              controller: emailC,
              decoration: InputDecoration(
                hintText: 'email',
              ),
            ),
            //password
            TextField(
              controller: passwordC,
              decoration: InputDecoration(
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
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
              child: Text('Daftar'),
            )
          ],
        ),
      ),
    );
  }
}
