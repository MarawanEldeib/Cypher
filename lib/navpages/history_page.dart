import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class historypage extends StatefulWidget {
  const historypage({Key? key}) : super(key: key);

  @override
  State<historypage> createState() => _historypageState();
}

class _historypageState extends State<historypage> {


  FirebaseDatabase database = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('History Page'),
        ),
        body: Center(child: Text("History page"),),
      ),
    );
  }
}
