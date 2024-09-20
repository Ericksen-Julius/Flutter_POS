// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';
import 'package:proyek_pos/page/DashboardPage.dart';
import 'package:proyek_pos/style/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _noIndukController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 10),
                Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 36,
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans Bold',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Isi informasi sesuai kolom berikut ini",
                  style: TextStyle(
                    fontSize: 14,
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans Regular',
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "No. induk",
                  style: TextStyle(
                    fontSize: 14,
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans Regular',
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _noIndukController,
                  style: TextStyle(color: primary),
                  decoration: InputDecoration(
                    hintText: "000001",
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary),
                    ),
                    filled: true, // tanda tf ada background color
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans Regular',
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  style: TextStyle(color: primary),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                      filled: true, // tanda tf ada background color
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lupa kata sandi?',
                    style: TextStyle(
                      color: primary,
                      fontFamily: 'Plus Jakarta Sans Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Aksi ketika tombol ditekan
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavbar()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(75, 16, 16, 1),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromRGBO(254, 253, 248, 1),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
