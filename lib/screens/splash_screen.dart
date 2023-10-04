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
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 100),
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Image.asset(
              'asset/Flashlogo1.1.jpg',
              width: 200,
            ),
            Text(
              'FLASH',
              style: TextStyle(
                  color: Colors.white38, letterSpacing: 5, fontSize: 20),
            ),
            SizedBox(
              height: 220,
            ),
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
