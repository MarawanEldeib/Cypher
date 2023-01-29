import 'dart:math';
import 'package:cypherflutter/navpages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/constants.dart';

class FingerprintStepper extends StatefulWidget {
  final String profileKey;
  final Function deleteAddedFingerprint;
  final String fingerprintKey;

  FingerprintStepper(
      this.profileKey, this.deleteAddedFingerprint, this.fingerprintKey);

  @override
  _FingerprintStepperState createState() => _FingerprintStepperState();
}

class _FingerprintStepperState extends State<FingerprintStepper> {
  void _deleteAddedFingerprint() {
    widget.deleteAddedFingerprint(widget.fingerprintKey);
  }

  int currentStep = 0;
  bool _isOptionChanged = true;

  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  void _changeOptionBack(String profileKey) async {
    DatabaseReference optionRef = databaseRef.child(user.uid).child('option');
    optionRef.set(2);
  }

  @override
  void initState() {
    super.initState();
    // Listen for changes to the "steps" node under the user's uid
    databaseRef.child(user.uid).child("steps").set(0);
    databaseRef.child(user.uid).child("steps").onValue.listen((event) {
      var step = int.parse(event.snapshot.value.toString());
      setState(() {
        currentStep = min(max(step - 1, 0), getSteps().length - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _deleteAddedFingerprint();
        if (_isOptionChanged) {
          _changeOptionBack(selectedProfileKey);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Setup fingerprint'),
          backgroundColor: appcolortheme,
        ),
        body: StreamBuilder(
            stream: databaseRef.child(user.uid).child("steps").onValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var value = snapshot.data.snapshot.value;
                if (value == null) {
                  print("value is null");
                  return Center(child: SpinKitFadingCircle(
                    color: Colors.red,
                  ));
                }
                try {
                  var step = int.parse(value.toString());
                  if (step > 0) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(primary: Colors.green),
                      ),
                      child: Stepper(
                        type: StepperType.vertical,
                        steps: getSteps(),
                        currentStep: currentStep,
                        controlsBuilder: (context, controller) {
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  } else {
                    return Center(child: SpinKitPouringHourGlassRefined(
                      color: Color(0xFF242038),
                    ));
                  }
                } catch (e) {
                  print("Not able to parse value: $value to int");
                  return Center(child: SpinKitFadingCircle(
                    color: Color(0xFF242038),
                  ));
                }
              } else {
                return Center(child: SpinKitFadingFour(
                  color: Color(0xFF242038),
                ));
              }
            }),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Scan Finger'),
          content: Container(),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Remove finger'),
          content: Container(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('Scan Finger Again'),
          content: Container(),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: Text('Success / Failure'),
          content: StreamBuilder(
              stream: databaseRef.child(user.uid).child("steps").onValue,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var value = snapshot.data.snapshot.value;
                  if (value == null) {
                    return Container();
                  }
                  try {
                    var step = int.parse(value.toString());
                    return Container(
                      child: Column(
                        children: [
                          Visibility(
                            visible: step == 4,
                            child: AlertDialog(
                              title: Text("Success"),
                              content: Text("Fingerprint Saved Successfully!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      if (_isOptionChanged) {
                                        _changeOptionBack(selectedProfileKey);
                                      };
                                    },
                                    child: Text("OK"))
                              ],
                            ),
                          ),
                          Visibility(
                            visible: step != 4,
                            child: SafeArea(
                              child: AlertDialog(
                                title: Text("Oops... Failed"),
                                content: Text("   Please try again!"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      _deleteAddedFingerprint();
                                      Navigator.pop(context);
                                      if (_isOptionChanged) {
                                        _changeOptionBack(selectedProfileKey);
                                      }
                                    },
                                  ),
                                ],
                                elevation: 24,
                                icon: Icon(Icons.cancel),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }),
        ),
      ];
}
