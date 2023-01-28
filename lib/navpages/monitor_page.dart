import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'noti.dart';

class monitorpage extends StatefulWidget {
  const monitorpage({Key? key}) : super(key: key);

  @override
  State<monitorpage> createState() => _monitorpageState();
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}

class _monitorpageState extends State<monitorpage> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  int? _distance;
  bool? _doorLocked;
  bool? _motion;
  bool _showError = false;

  void _unlockDoor() async {
    try {
      // update the status of door in firebase
      _doorLocked = false;
      await databaseRef.child(user.uid).update({
        'doorLocked': _doorLocked,
      });
    } catch (e) {
      _showError = true;
      print(e);
    }
  }

  void _lockDoor() async {
    try {
      // update the status of door in firebase
      _doorLocked = true;
      await databaseRef.child(user.uid).update({
        'doorLocked': _doorLocked,
      });
    } catch (e) {
      _showError = true;
      print(e);
    }
  }



  void _activateListeners() {
    databaseRef
        .child(user.uid.toString())
        .child('distance')
        .onValue
        .listen((event) {
      setState(() {
        _distance = int.parse(event.snapshot.value.toString());
      });
    });

    databaseRef
        .child(user.uid.toString())
        .child('doorLocked')
        .onValue
        .listen((event) {
      setState(() {
        _doorLocked = event.snapshot.value.toString().parseBool();
      });
    });

    databaseRef
        .child(user.uid.toString())
        .child('motion')
        .onValue
        .listen((event) {
      setState(() {
        _motion = event.snapshot.value.toString().parseBool();
      });
      if (_motion == true) {
// show notification when motion is detected
        NotificationController.createNewNotification();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Page'),
      ),
      body: SafeArea(
        child: _distance == null || _doorLocked == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Main account:',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          user.email.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Door Status: ' +
                              (_doorLocked == true ? 'Locked' : 'Unlocked'),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: _doorLocked ?? false
                                            ? Icon(
                                                Icons.lock,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons.lock_open,
                                                color: Colors.white,
                                              ),
                                      ),
                                      TextSpan(
                                        text: _doorLocked ?? false
                                            ? ' Unlock'
                                            : ' Lock',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: _doorLocked ?? false
                                      ? Colors.lightGreen
                                      : Colors.red,
                                ),
                                onPressed: _doorLocked ?? false
                                    ? _unlockDoor
                                    : _lockDoor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: _showError ? 30 : 0,
                          child: _showError
                              ? Text(
                                  'Error unlocking door. Please try again.',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  Text(
                      'Motion: ' +
                          (_motion == true ? ' Detected' : 'Not Detected'),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Visibility(
                    visible: _motion ?? false,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: Text(
                        'Object Distance: ' + _distance.toString() + ' cm',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}