// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyek_pos/main.dart';
import 'package:proyek_pos/model/UserModel.dart';
import 'package:proyek_pos/page/BottomNavbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = 'Loading...'; // Placeholder for name
  String position = 'Loading...'; // Placeholder for position

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when profile page is initialized
  }

  Future<void> _loadUserData() async {
    String? userData = sp.getString('admin');

    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData);
      User user = User.fromJson(userMap);

      setState(() {
        name = user.name; // Replace John Doe
        position = user.jabatan; // Replace Manager with actual position
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Instead of going back to the onboarding page, navigate to the dashboard or stay in BottomNavbar
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavbar()));
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
                color: Color.fromRGBO(75, 16, 16, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Plus Jakarta Sans Bold'),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xFFFCF3EC),
                Color(0xFFFFFFFF),
              ])),
          child: Column(
            children: [
              // Centered Icon
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(75, 16, 16, 1),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      position,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(75, 16, 16, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
