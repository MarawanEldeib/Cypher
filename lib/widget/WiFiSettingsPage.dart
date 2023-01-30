import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

import 'constants.dart';

class WiFiSettingsPage extends StatefulWidget {
  @override
  _WiFiSettingsPageState createState() => _WiFiSettingsPageState();
}

class _WiFiSettingsPageState extends State<WiFiSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wi-Fi Settings"),
        backgroundColor: appcolortheme,
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text("Wi-Fi Settings"),
                Card(
                  color: appcolortheme,
                  child: ListTile(
                    leading: Icon(Icons.wifi,color: Colors.white,),
                    title: Text('Wi-fi Settings', style: TextStyle(color: Colors.white),),
                    onTap: () {
                      OpenSettings.openWIFISetting();
                    },
                  ),
                ),
                // Add the necessary code to display the Wi-Fi settings here.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
