import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      'Main account:',
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.green),
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
                    backgroundColor: Colors.pink),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                },
                icon: Icon(Icons.wifi),
                label: Text('Wi-fi Settings'),
              ),
              SizedBox(height: 30,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.red),
                onPressed: () async {
                  var url = Uri.parse("tel:999");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: Icon(Icons.phone),
                label: Text('Emergency Call'),
              ),
            ],
          )),
    );
  }
}
