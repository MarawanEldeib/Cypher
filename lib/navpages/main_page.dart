import 'package:cypherflutter/navpages/profile_page.dart';
import 'package:cypherflutter/navpages/history_page.dart';
import 'package:cypherflutter/navpages/monitor_page.dart';
import 'package:cypherflutter/navpages/settings_page.dart';
import 'package:flutter/material.dart';

late final Widget activeIcon;
late final Widget icon;

class mainpage extends StatefulWidget {
  const mainpage({Key? key}) : super(key: key);

  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  List pages = [
    monitorpage(),
    ProfileListPage(),
    historypage(),
    settingspage(),
  ];
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.monitor_outlined),
              label: 'Monitor',
              activeIcon: Icon(Icons.monitor)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profiles',
              activeIcon: Icon(Icons.person)),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: 'History',
              activeIcon: Icon(Icons.notifications)),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
              activeIcon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}




