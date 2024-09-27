// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/UserModel.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';
import 'package:proyek_pos/style/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // User? admin;

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
                      login(_noIndukController.text, _passwordController.text);
                      // Aksi ketika tombol ditekan
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => BottomNavbar()));
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

  Future<void> login(id, password) async {
    // print(sp.getString('admin'));
    // print(sp.getString('usersLocal'));
    // return;
    const url = "http://10.0.2.2:8082/proyek_pos/login";
    final uri = Uri.parse(url);
    try {
      final response = await http
          .post(
        uri,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {
            "user_id": id,
            "password": password,
          },
        ),
      )
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw TimeoutException("Connection timeout");
      });
      final body = response.body;
      final jsonBody = jsonDecode(body);
      // sp.remove('usersLocal');
      if (response.statusCode == 200) {
        if (jsonBody['success']) {
          User admin = User.fromJson(jsonBody['user']);
          // print('cek');
          // print(User.fromJson(jsonBody['user']).name);
          // return;
          await sp.setString('admin', jsonEncode(admin.toJson()));
          String? usersLocal = sp.getString('usersLocal');
          List<User> users = [];
          List<dynamic> userList = jsonDecode(usersLocal ?? '[]');
          users = userList.map((item) => User.fromJson(item)).toList();
          bool userExists = users.any((user) => user.userId == admin.userId);
          if (!userExists) {
            users.add(admin);
            String updatedUsersJson =
                jsonEncode(users.map((user) => user.toJson()).toList());
            await sp.setString('usersLocal', updatedUsersJson);
            // print("User added to SharedPreferences");
          } else {
            // print("User already exists in SharedPreferences");
          }
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNavbar()));
          // print(sp.getString('usersLocal'));
          // print(sp.getString('admin'));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text("User not found"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              );
            },
          );
        }
      } else {
        List<dynamic> usersList =
            jsonDecode(sp.getString('usersLocal') ?? '[]');
        List<User> users =
            usersList.map((item) => User.fromJson(item)).toList();

        User? foundUser;
        try {
          foundUser = users.firstWhere(
            (user) => user.userId.toString() == id && user.password == password,
          );
        } catch (e) {
          foundUser = null;
        }
        if (foundUser != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNavbar()));
          await sp.setString('admin', jsonEncode(foundUser.toJson()));

          // print("User found: ${foundUser.name}");
          // Lakukan aksi setelah menemukan user (misalnya login)
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text("User not found or password is incorrect"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              );
            },
          );
          // Aksi jika user tidak ditemukan
        }
      }
    } catch (e) {
      print('error login: $e');
      List<dynamic> usersList = jsonDecode(sp.getString('usersLocal') ?? '[]');
      List<User> users = usersList.map((item) => User.fromJson(item)).toList();
      // print(usersList);
      // print(id);
      // print(password);

      User? foundUser;
      try {
        foundUser = users.firstWhere(
          (user) => user.userId.toString() == id && user.password == password,
        );
      } catch (e) {
        foundUser = null;
      }
      if (foundUser != null) {
        await sp.setString('admin', jsonEncode(foundUser.toJson()));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavbar()));
        // print("User found: ${foundUser.name}");
        // Lakukan aksi setelah menemukan user (misalnya login)
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Failed",
                style: TextStyle(color: Colors.red),
              ),
              content: Text("User not found or password is incorrect"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
        // Aksi jika user tidak ditemukan
      }
    }
  }
}
