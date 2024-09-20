import 'package:flutter/material.dart';
import 'package:proyek_pos/page/DashboardPage.dart';
import 'package:proyek_pos/page/Profile.dart';
import 'package:proyek_pos/page/Riwayat.dart';


class BottomNavbar extends StatefulWidget {
  BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int indexNow = 0; 
  final List<Widget> _pages = [
    Dashboardpage(),
    Riwayat(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 235, 222, 1),
      body: _pages[indexNow], 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(255, 235, 222, 1),
        unselectedItemColor: Color.fromRGBO(90, 27, 27, 1),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "Riwayat",
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: indexNow,
        selectedItemColor: Color.fromRGBO(90, 27, 27, 1),
        onTap: (int index) {
          setState(() {
            indexNow = index;
          });
        },
      ),
    );
  }
}
