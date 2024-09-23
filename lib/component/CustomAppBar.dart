// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;

  const CustomAppBar({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(254, 253, 248, 1),
      title: Text(
        title, // Use the title parameter here
        style: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(75, 16, 16, 1),
          fontFamily: 'Plus Jakarta Sans Bold',
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: icon != null ? Icon(icon) : null, // Use the optional icon
    );
  }

  // Define the preferred size for the AppBar
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
