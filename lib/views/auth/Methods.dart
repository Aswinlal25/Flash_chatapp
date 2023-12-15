import 'package:chat_app/services/apis/api.dart';
import 'package:chat_app/views/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount( String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    UserCredential authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult.user;

    if (user != null) {
      print('Account created successfully');
      return user;
    } else {
      // Account creation failed
      throw Exception('Account creation failed');
    }
  } catch (e) {
    print('Error creating account: $e');
    throw e;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    UserCredential authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult.user;

    if (user != null) {
      print('Login successful');
      return user;
    } else {
      // Login failed
      throw Exception('Login failed');
    }
  } catch (e) {
    print('Error logging in: $e');
    throw e;
  }
}

Future<void> logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
await APIs.updateActiveStatus(false);

    await _auth.signOut().then((value) {
      print("the function is called");
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
    });
  } catch (e) {
    print('Error logging out: $e');
    throw e;
  }
}
