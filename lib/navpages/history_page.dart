import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  late String _profileName;
  late String _dateTime;
  int? _savedID;


  void _activateListeners() {
    // Listen for changes to the savedID value
    databaseRef.child(user.uid).child("savedID").onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      _savedID = snapshot.value as int;
      _updateHistory();
    });
  }

  Future<void> _updateHistory() async {
    // Check if the history node exists
    final DataSnapshot historySnapshot = await databaseRef.child(user.uid).child("history").get();
    if (!historySnapshot.exists) {
      // If the history node does not exist, create it
      databaseRef.child(user.uid).child("history").set({});
    }
    // Check all fingerprints under all profiles until a match is found
    final DataSnapshot snapshot =
    await databaseRef.child(user.uid).child("profiles").get();
    final Map<dynamic, dynamic> profiles =
    (snapshot.value as Map<dynamic, dynamic>);
    for (final dynamic profile in profiles.values) {
      if (profile['fingerprints'] != null) {
        for (final dynamic fp in profile['fingerprints'].values) {
          if (fp == _savedID) {
            _profileName = profile['name'];
            final DateTime currentTime = DateTime.now();
            // format the date and time
            _dateTime = DateFormat('dd-MM-yyyy HH:mm').format(currentTime);
            // add the profile name, date and time to the Firebase Realtime Database history collection
            databaseRef.child(user.uid).child("history").push().set({
              'profileName': _profileName,
              'dateTime': _dateTime,
            });
            return;
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: databaseRef.child(user.uid).child("history").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Checking for history..."),
            );
          }
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            final List history = (snapshot.data?.snapshot.value as Map<dynamic, dynamic>).values.toList();
            if(history.length > 0) {
              history.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final dynamic item = history[index];
                  return ListTile(
                    title: Text(item['profileName'] + ' came home'),
                    subtitle: Text(item['dateTime']),
                  );
                },
              );
            }
            else {
              return Center(
                child: Text("No history found"),
              );
            }
          } else {
            return Center(
              child: Text("No history found"),
            );
          }
        },
      ),
    );
  }
}
