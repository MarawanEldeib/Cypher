import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

class settingspage extends StatefulWidget {
  const settingspage({Key? key}) : super(key: key);

  @override
  State<settingspage> createState() => _settingspageState();
}

class _settingspageState extends State<settingspage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Settings page"),
              SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.green
                ),
                icon: Icon(Icons.logout, size: 32),
                label: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.pink
                ),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                },
                icon: Icon(Icons.wifi),
                label: Text('Wi-fi Settings'),
              ),
            ],
          )),
    );
  }
}
