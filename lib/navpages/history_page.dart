import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class historypage extends StatefulWidget {
  const historypage({Key? key}) : super(key: key);

  @override
  State<historypage> createState() => _historypageState();
}

class _historypageState extends State<historypage> {

  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  String _name = "";
  String _time = "";
  List<String> _notifications = [];

  void _getName() {
    databaseRef.child(user.uid).child("savedID").onValue.listen((event) {
      int savedId = int.parse(event.snapshot.value.toString());
      // search for the savedId in all profiles
      databaseRef.child(user.uid).child("profiles").once().then((snapshot) {
        DatabaseEvent event = snapshot;
        Map<dynamic, dynamic> profiles = event.snapshot.value as Map<dynamic, dynamic>;
        if (profiles != null) {
          profiles.forEach((profileKey, profile) {
            databaseRef
                .child(user.uid)
                .child("profiles")
                .child(profileKey)
                .child("fingerprints")
                .once()
                .then((snapshot) {
              DatabaseEvent event = snapshot;
              Map<dynamic, dynamic> fingerprints = event.snapshot.value as Map<dynamic, dynamic>;
              if (fingerprints != null) {
                fingerprints.forEach((fingerprintKey, fingerprint) {
                  if (fingerprint.fingerprintKey == savedId) {
                    setState(() {
                      _name = profile["name"];
                      _time = DateTime.now().toString();
                      _notifications.add("$_name came home at $_time");
                    });
                  }
                });
              }
            });
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('History Page'),
        ),
        body: _notifications.length == 0
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_notifications[index]),
            );
          },
        ),
      ),
    );
  }
}
