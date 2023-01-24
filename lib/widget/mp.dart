import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../navpages/main_page.dart';
import 'login_widget.dart';

class mp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('something wrong');
            return Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return mainpage();
          } else {
            print('login widget');
            return LoginWidget();
          }
        },
      ),
    );
  }
}