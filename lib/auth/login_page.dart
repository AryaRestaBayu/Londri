import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:londri/auth/register_page.dart';
import 'package:londri/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

TextEditingController emailC = TextEditingController();
TextEditingController passwordC = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFDEF0F2),
        body: Center(
          child: SizedBox(
            height: sizeHeight,
            width: sizeWidth * 0.85,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //teks londri
                    Container(
                      height: sizeHeight * 0.08,
                      width: sizeWidth * 0.60,
                      child: Image(image: AssetImage('images/londri.png')),
                    ),
                    SizedBox(
                      height: sizeHeight * 0.07,
                    ),
                    //form login
                    Container(
                      height: sizeHeight * 0.52,
                      width: sizeWidth * 0.80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(
                            height: sizeHeight * 0.03,
                          ),
                          //text login
                          Text(
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          SizedBox(
                            height: sizeHeight * 0.03,
                          ),
                          //email
                          Container(
                            width: sizeWidth * 0.70,
                            height: sizeHeight * 0.07,
                            decoration: BoxDecoration(
                                color: Color(0xFFDEF0F2),
                                borderRadius: BorderRadius.circular(30)),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailC,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(Icons.person, size: 26),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sizeHeight * 0.03,
                          ),
                          //password
                          Container(
                            width: sizeWidth * 0.70,
                            height: sizeHeight * 0.07,
                            decoration: BoxDecoration(
                                color: Color(0xFFDEF0F2),
                                borderRadius: BorderRadius.circular(30)),
                            child: TextField(
                              obscureText: true,
                              controller: passwordC,
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(Icons.lock, size: 26),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                hintText: 'password',
                              ),
                            ),
                          ),
                          //lupa password
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Lupa password?',
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                          SizedBox(
                            height: sizeHeight * 0.03,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              fixedSize:
                                  Size(sizeWidth * 0.30, sizeHeight * 0.06),
                              backgroundColor: Colors.lightBlueAccent[200],
                              elevation: 0,
                            ),
                            onPressed: () async {
                              AuthService().login(emailC.text.trim(),
                                  passwordC.text.trim(), context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            height: sizeHeight * 0.02,
                          ),
                          RichText(
                              text: TextSpan(
                            text: 'Belum memiliki akun?',
                            style: TextStyle(color: Colors.black),
                            children: [
                              WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => RegisterPage()),
                                            (route) => false),
                                  text: 'Daftar',
                                  style: TextStyle(color: Colors.blue)),
                            ],
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
