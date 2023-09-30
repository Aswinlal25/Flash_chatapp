import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'auth/login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    checkAuthenticationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 34, 33, 33),
      body: Padding(
        padding: const EdgeInsets.only(left: 93),
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Image.asset(
              'asset/flogo.png',
              width: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'FLASH',
              style: TextStyle(
                  color: Colors.white, letterSpacing: 1, fontSize: 28),
            ),
            SizedBox(
              height: 250,
            ),
            Text(
              'Light Up Your Chat With Flash',
              style: TextStyle(
                  color: Colors.white, letterSpacing: 0.3, wordSpacing: 2,fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  void checkAuthenticationState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      print(
          'User authentication status: ${user != null ? 'Authenticated' : 'Not Authenticated'}');
      if (user != null) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        });
      } else {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      }
    });
  }
}
