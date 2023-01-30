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
                Text(
                  "Connecting Your System to the Internet",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                    "1. Turn on your system. The server that connects to the internet will automatically start working."),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("2. Go to your device's WiFi settings."),
                ),
                SizedBox(height: 10),
                Card(
                  color: appcolortheme,
                  child: ListTile(
                    leading: Icon(
                      Icons.wifi,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Wi-fi Settings',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      OpenSettings.openWIFISetting();
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                    "3. Look for a WiFi network named 'Cypher' and enter the password 'password' or scan the QR code on the back of the box using your phone's QR scanner."),
                SizedBox(height: 10),
                Text(
                    "4. Press 'Connect.' A server window will open on your phone."),
                SizedBox(height: 10),
                Text(
                    "5. You will see a list of available networks in the area. Select the network you want your system to connect to by clicking on it."),
                SizedBox(height: 10),
                Text(
                    "6. Enter the password for the selected network and press 'Save'."),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "7. Your system will now be connected to the internet."),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Note:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ),
                Text(
                    "If you want to change the network your system is connected to, turn off the previously saved network. This will disconnect the system from the network and allow you to connect to a different one by following the steps above."),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
