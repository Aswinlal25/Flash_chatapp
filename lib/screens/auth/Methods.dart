import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async {
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
    await _auth.signOut().then((value) {
       Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    });
  } catch (e) {
    print('Error logging out: $e');
    throw e;
  }
}
