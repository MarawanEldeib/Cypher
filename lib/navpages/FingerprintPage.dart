import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../widget/AddFingerprintDialog.dart';
import 'FingerprintStepper.dart';

class FingerprintPage extends StatefulWidget {
  final String profileKey;
  final List fingerprints;

  FingerprintPage({required this.profileKey, required this.fingerprints});

  @override
  State<FingerprintPage> createState() => _FingerprintPageState();
}

String selectedProfileKey = '';

class _FingerprintPageState extends State<FingerprintPage> {
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  int? fingerprint;
  String profileKey = '';

  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  bool _isOptionChanged = false;

  void _changeOption(String profileKey) async {
    DatabaseReference optionRef = databaseRef.child(user.uid).child('option');
    optionRef.set(1);
    _isOptionChanged = true;
  }

  void _addFingerprint(String profileKey, int fingerprint, Function callback) async {
    DatabaseReference profilesRef = databaseRef.child(user.uid).child('profiles');
    final DatabaseEvent event = await profilesRef.once();
    final DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic>? profiles = snapshot.value as Map?;
    if (profiles != null) {
      for (var profile in profiles.values) {
        if(profile['fingerprints']!= null) {
          for (var fp in profile['fingerprints'].values) {
            if (fp == fingerprint) {
              //fingerprint already exists
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text("Fingerprint already exists"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              return;
            }
          }
        }
      }
    }
    // Generate a unique key for the new fingerprint node
    DatabaseReference fingerprintsRef = databaseRef.child(user.uid).child('profiles').child(profileKey).child('fingerprints');
    DatabaseReference fingerprintRef = fingerprintsRef.push();
    // Use the generated key to set the value of the fingerprint id
    fingerprintRef.set(fingerprint);
    var fingerprintKey = fingerprintRef.key;
    callback(fingerprintKey);
  }


  void _deleteFingerprint(String profileKey, String fingerprintKey) async {
    // Get a reference to the fingerprint node using the profileKey and fingerprint key
    DatabaseReference fingerprintRef = FirebaseDatabase.instance
        .ref()
        .child(user.uid)
        .child('profiles')
        .child(profileKey)
        .child('fingerprints')
        .child(fingerprintKey);
    // Delete the fingerprint node
    fingerprintRef.remove();
  }

  void _deleteAddedFingerprint(String fingerprintKey) async {
    // Get a reference to the recently added fingerprint node using the fingerprint key
    DatabaseReference fingerprintRef = FirebaseDatabase.instance
        .ref()
        .child(user.uid)
        .child('profiles')
        .child(widget.profileKey)
        .child('fingerprints')
        .child(fingerprintKey);
    // Delete the fingerprint node
    fingerprintRef.remove();
  }

  Future<void> _refreshData() async {
    // Code to refresh data from Firebase
    setState(() {});
    //...
    _refreshKey.currentState?.show();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fingerprints'),
        actions: [
          IconButton(
            icon: Icon(Icons.fingerprint),
            onPressed: () async {
              _changeOption(widget.profileKey);
              // Show the dialog to add the fingerprint ID
              int fingerprint = await showDialog(
                context: context,
                builder: (context) => AddFingerprintDialog(),
              );

              // If the user entered a fingerprint ID
              if (fingerprint != null) {
                _addFingerprint(widget.profileKey, fingerprint,
                    (fingerprintKey) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FingerprintStepper(
                            widget.profileKey,
                            _deleteAddedFingerprint,
                            fingerprintKey)),
                  );
                });
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: StreamBuilder(
          stream: databaseRef
              .child(user.uid)
              .child('profiles')
              .child(widget.profileKey)
              .child('fingerprints')
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var value = snapshot.data?.snapshot.value;
              if (value is Map) {
                Map fingerprints = value;
                if (fingerprints.keys.length > 0) {
                  return ListView.builder(
                    itemCount: fingerprints.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm deletion"),
                                content: Text(
                                    "Are you sure you want to delete this fingerprint?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _deleteFingerprint(widget.profileKey,
                                          fingerprints.keys.elementAt(index));
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
                          title: Text(
                              fingerprints.values.elementAt(index).toString()),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No fingerprints saved'),
                  );
                }
              } else {
                return Center(
                  child: Text('No fingerprints saved'),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
