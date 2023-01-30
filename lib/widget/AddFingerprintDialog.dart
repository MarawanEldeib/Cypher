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
  String _errorText = "";

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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                if (int.tryParse(value) != null &&
                    int.parse(value) >= 1 &&
                    int.parse(value) <= 127) {
                  _fingerprintId = int.parse(value);
                  _errorText = "";
                } else {
                  _fingerprintId = null;
                  _errorText = "Please enter an integer between 1 and 127";
                }
                setState(() {});
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightGreen),
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Fingerprint ID',
                labelStyle: TextStyle(color: Colors.black),
                errorText: _errorText,
              ),
            ),
          ],
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
            child: Text('Add',style: TextStyle(color: Colors.green),),
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
