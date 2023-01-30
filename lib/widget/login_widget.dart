import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();
  _SupportState _supportState = _SupportState.unknown;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _isSaved = false;
  late String _email;
  late String _password;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _checkSavedCredentials();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _saveCredentials() async {
    await _storage.write(key: 'email', value: _emailController.text);
    await _storage.write(key: 'password', value: _passwordController.text);
  }

  Future<void> _checkSavedCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    if (email != null && password != null) {
      _isSaved = true;
      _email = email;
      _password = password;
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Touch the fingerprint sensor',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }
    if (_isSaved && authenticated) {
      _emailController.text = _email;
      _passwordController.text = _password;
    }
    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: SpinKitFadingFour(
              color: appcolortheme,
            ),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _saveCredentials();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        Navigator.pop(context);
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Incorrect Email or Password',
          text: 'Please enter your correct user details',
          backgroundColor: kInactiveCardColor,
          titleColor: Colors.white,
          textColor: Colors.white,
          confirmBtnColor: kBottomContainerColor,
          confirmBtnText: 'OK',
        );
      } else if (e.code == 'unknown') {
        Navigator.pop(context);
        return QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Missing Email or Password',
          text: 'Please fill your correct user details',
          backgroundColor: kInactiveCardColor,
          titleColor: Colors.white,
          textColor: Colors.white,
          confirmBtnColor: kBottomContainerColor,
          confirmBtnText: 'OK',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: Color(0xFF242038)),
        scaffoldBackgroundColor: appcolortheme,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    child: Image.asset(
                      'assets/logo_foreground.png',
                      height: 300,
                    ),
                  ),
                ),
                Text(
                  'Welcome Back!',
                  style: kResultTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Please enter your credentials',
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      suffixIcon: GestureDetector(
                          onTap: () => _authenticate(),
                      child: Icon(Icons.fingerprint,),),
                      labelStyle: kLabelTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.vpn_key),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      suffixIconColor: _obscureText ? Colors.green : Colors.red,
                      labelText: 'Password',
                      labelStyle: kLabelTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'SIGN IN',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kBottomContainerColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
