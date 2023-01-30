import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/constants.dart';
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
        backgroundColor: appcolortheme,
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
                        child: Text('Create'),
                        onPressed: () {
                          // Pass the value of the entered name to the _addProfile method
                          _addProfile(name);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(appcolortheme)),
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
            return Center(
                child: SpinKitFadingFour(
              color: appcolortheme,
            ));
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
                        Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            // Show a confirmation dialog before deleting the profile
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm deletion"),
                                  content: Text(
                                      "Are you sure you want to delete this profile?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Delete", style: TextStyle(color: Colors.red),),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _deleteProfile(key);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          background: Container(color: Colors.red),
                          secondaryBackground: Container(
                            color: Colors.red,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.delete),
                                    Text("Deleting...")
                                  ],
                                )),
                          ),
                          child: ListTile(
                            title: Text(name),
                            subtitle: ListView.builder(
                                shrinkWrap: true,
                                itemCount: fingerprints.length,
                                itemBuilder: (context, index) {
                                  return Text(fingerprints[index]);
                                }),
                          ),
                        )
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
