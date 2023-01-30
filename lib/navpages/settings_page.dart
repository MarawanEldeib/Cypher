import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/WiFiSettingsPage.dart';
import '../widget/constants.dart';

class settingspage extends StatefulWidget {
  const settingspage({Key? key}) : super(key: key);

  @override
  State<settingspage> createState() => _settingspageState();
}

class _settingspageState extends State<settingspage> {
  final user = FirebaseAuth.instance.currentUser!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: appcolortheme,
      ),
      body: Padding(
          padding: EdgeInsets.all(27),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user.email.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.wifi_protected_setup_rounded),
                  title: Text("Wi-Fi Connection"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WiFiSettingsPage()),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading: Icon(Icons.phone, color: Colors.red),
                  title: Text('Emergency Call',
                      style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    var url = Uri.parse("tel:999");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.green, size: 32),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.green, fontSize: 24),
                  ),
                  onTap: () => FirebaseAuth.instance.signOut(),
                ),
              ),
            ],
          )),
    );
  }
}
