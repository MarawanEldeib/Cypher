import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../widget/constants.dart';
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

  void _unlockDoor() async {
    // update the status of door in firebase
    _doorLocked = false;
    await databaseRef.child(user.uid).update({
      'doorLocked': _doorLocked,
    });
  }

  void _lockDoor() async {
    // update the status of door in firebase
    _doorLocked = true;
    await databaseRef.child(user.uid).update({
      'doorLocked': _doorLocked,
    });
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
    final now = DateTime.now();
    String greeting = '';
    if (now.hour < 12) {
      greeting = ' Good morning!';
    } else if (now.hour < 17) {
      greeting = ' Good afternoon!';
    } else {
      greeting = ' Good evening!';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Page'),
        backgroundColor: appcolortheme,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: _distance == null || _doorLocked == null
              ? Center(
                  child: SpinKitFadingFour(
                  color: appcolortheme,
                ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      greeting,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '  Door lock',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  _doorLocked == true
                                      ? 'assets/doorlocked.png'
                                      : 'assets/door.png',
                                  height: 100,
                                ),
                                SizedBox(width: 20),
                                TextButton(
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
                                            color: Colors.white,
                                            fontSize: 25,
                                          ),
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
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  (_doorLocked == true
                                      ? '        Locked'
                                      : '        Unlocked'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: appcolortheme,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 100),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '  Movement Detection',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                        child: Column(children: [
                      Container(
                        width: 390,
                        height: 120,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: appcolortheme,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  width: 75,
                                  height: 75,
                                  child: Image.asset(
                                    'assets/motion.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Motion:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: appcolortheme,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _motion != null && _motion!
                                            ? 'Detected'
                                            : 'Not Detected',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: _motion != null && _motion!
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Visibility(
                          visible: _motion ?? false,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: appcolortheme,
                              borderRadius: BorderRadius.circular(17),
                              border:
                                  Border.all(width: 2, color: appcolortheme),
                            ),
                            child: Text(
                              'Object Distance: ' +
                                  _distance.toString() +
                                  ' cm',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]))
                  ],
                ),
        ),
      ),
    );
  }
}
