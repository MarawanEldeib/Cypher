import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'FingerprintPage.dart';

class ProfileListPage extends StatefulWidget {
  @override
  _ProfileListPageState createState() => _ProfileListPageState();
}

String selectedProfileKey = '';

class _ProfileListPageState extends State<ProfileListPage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  String name = '';
  int? fingerprint;
  String profileKey = '';

  void _addProfile(String name) async {
    // Generate a push ID for the new profile
    DatabaseReference profileRef =
        databaseRef.child(user.uid).child('profiles').push();
    // Assign the push ID to the profileKey variable
    profileKey = profileRef.key!;
    // Use the generated push ID as the key for the new profile
    profileRef.set({'name': name});
  }

  void _deleteProfile(String profileKey) async {
    DatabaseReference profileRef =
        databaseRef.child(user.uid).child('profiles').child(profileKey);
    profileRef.remove();
  }

  void _addFingerprint(int fingerprint) async {
    // Generate a unique key for the new fingerprint node
    DatabaseReference fingerprintRef = databaseRef
        .child(user.uid)
        .child('profiles')
        .child(selectedProfileKey)
        .child('fingerprints')
        .push();
    // Use the generated key to set the value of the fingerprint id
    fingerprintRef.set(fingerprint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profiles'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add a Profile'),
                    content: TextField(
                      onChanged: (value) {
                        // Set the value of the entered name to a local variable
                        name = value;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreen),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Enter Profile Name',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        child: Text('Add'),
                        onPressed: () {
                          // Pass the value of the entered name to the _addProfile method
                          _addProfile(name);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: databaseRef.child(user.uid).child('profiles').onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.snapshot.value is Map) {
            return ListView.builder(
              itemCount: (snapshot.data!.snapshot.value as Map).keys.length,
              itemBuilder: (context, index) {
                String key = (snapshot.data!.snapshot.value as Map)
                    .keys
                    .elementAt(index);
                String name =
                    (snapshot.data!.snapshot.value as Map)[key]['name'];
                List fingerprints;
                if ((snapshot.data?.snapshot.value as Map)[key]['fingerprints']
                    is List) {
                  fingerprints = (snapshot.data?.snapshot.value as Map)[key]
                      ['fingerprints'];
                } else {
                  fingerprints = [];
                }

                return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => FingerprintPage(
                              profileKey: key, fingerprints: fingerprints),
                        )),
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(name),
                            subtitle: ListView.builder(
                                shrinkWrap: true,
                                itemCount: fingerprints.length,
                                itemBuilder: (context, index) {
                                  return Text(fingerprints[index]);
                                }),
                            trailing: Column(children: [
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                  PopupMenuItem(
                                    value: 'add_fingerprint',
                                    child: Text('Add Fingerprint'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    // Pass the profile key to the _deleteProfile method
                                    _deleteProfile(key);
                                  } else if (value == 'add_fingerprint') {
                                    // Show a dialog to enter the fingerprint value
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Add Fingerprint ID'),
                                          content: TextField(
                                            onChanged: (value) {
                                              // Set the value of the entered fingerprint to a local variable
                                              fingerprint = int.parse(value);
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.lightGreen),
                                              ),
                                              border: OutlineInputBorder(),
                                              labelText: 'Enter Fingerprint ID',
                                              labelStyle: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              child: Text('Add'),
                                              onPressed: () {
                                                // Pass the profile key and fingerprint value to the _addFingerprint method
                                                selectedProfileKey = key;
                                                _addFingerprint(fingerprint!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ]))
                      ],
                    ));
              },
            );
          }

          return Center(
              child: Text(
                  "              No profiles \npress '+' to add new profile"));
        },
      ),
    );
  }
}
