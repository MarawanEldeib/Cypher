import 'package:cypherflutter/navpages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFingerprintDialog extends StatefulWidget {

  @override
  _AddFingerprintDialogState createState() => _AddFingerprintDialogState();
}

class _AddFingerprintDialogState extends State<AddFingerprintDialog> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  int? _fingerprintId;

  void _changeOptionBack(String profileKey) async {
    DatabaseReference optionRef = databaseRef.child(user.uid).child('option');
    optionRef.set(2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _changeOptionBack(selectedProfileKey);
        return true;
      },
      child: AlertDialog(
        title: Text('Add Fingerprint'),
        content: TextField(
          onChanged: (value) {
            _fingerprintId = int.parse(value);
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightGreen),
            ),
            border: OutlineInputBorder(),
            labelText: 'Enter Fingerprint ID',
            labelStyle: TextStyle(color: Colors.black),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              _changeOptionBack(selectedProfileKey);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (_fingerprintId != null) {
                Navigator.of(context).pop(_fingerprintId);
              }
            },
          ),
        ],
      ),
    );
  }
}
