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
                                ],
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    // Pass the profile key to the _deleteProfile method
                                    _deleteProfile(key);
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
