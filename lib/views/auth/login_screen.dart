// import 'package:chat_app/hive_model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import '../../services/apis/api.dart';
import '../../common_widgets/dialogs/policy_dialog.dart';
import '../home_screen/home_screen.dart';
import 'Methods.dart';
import 'account_creation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/123.jpg'),

            // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Text(
                  'Welcome to',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                Text(
                  'FLASH',
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.w100),
                ),
                Text(
                  ' Login to Continue !',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 130),
                Container(
                  width: 330,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: Colors.black, letterSpacing: 2, fontSize: 15),
                      prefixIcon:
                          Icon(Icons.email, color: Colors.black, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white60.withOpacity(0.8), // Add opacity
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 330,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    // color: Colors.white.withOpacity(0.8), // Add opacity
                  ),
                  child: TextField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.black, letterSpacing: 2, fontSize: 15),
                      prefixIcon:
                          Icon(Icons.lock, color: Colors.black, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white60.withOpacity(0.8), // Add opacity
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 90),
                Padding(
                  padding: const EdgeInsets.only(left: 93),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        showProgressBar(context);
                        //MyWidget();
                        // Simulate login by delaying for 2 seconds
                        Future.delayed(Duration(seconds: 2), () {
                          if (_email.text.isNotEmpty &&
                              _password.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            logIn(_email.text.trim(), _password.text.trim())
                                .then((user) async {
                              if (user != null) {
                                print('Login Successful');
                                setState(() {
                                  isLoading = false;
                                });
                                if ((await APIs.userExists())) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()),(route) => false,);
                                  _showSnackBar(context, 'Login Successful!',
                                      Colors.black);
                                } else {
                                  await APIs.createUser().then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeScreen()));
                                    _showSnackBar(context, 'Login Successful!',
                                        Colors.black);
                                  });
                                }
                              } else {
                                print('Login Failed');
                                setState(() {
                                  isLoading = false;
                                });
                                _showSnackBar(
                                    context,
                                    'Login Failed. Please try again.',
                                    Colors.amber);
                              }
                            });
                          }
                        });
                      } else {
                        print('Please fill out the form correctly');
                        _showSnackBar(
                            context,
                            'Please fill out the form correctly.',
                            Colors.black);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, letterSpacing: 1.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 84, 83, 83),
                      onPrimary: Colors.white,
                      minimumSize: Size(150, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountCreateScreen()));
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left:width*0.31),
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  height: 127,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text:
                            "   By creating an account, you are agreeing to our   ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Privacy and policy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PolicyDialog(
                                          mdFileName: 'privacy_policy.md');
                                    });
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PolicyDialog(
                                          mdFileName: 'terms_conditions.md');
                                    });
                              },
                          ),
                        ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, letterSpacing: 1),
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.fixed,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(top: 550),
        child: Center(
            child: SimpleAnimationProgressBar(
          height: 4,
          width: 250,
          backgroundColor: Colors.white24,
          foregrondColor: Colors.blue,
          ratio: 0.5,
          direction: Axis.horizontal,
          curve: Curves.fastEaseInToSlowEaseOut,
          duration: const Duration(seconds: 2),
          borderRadius: BorderRadius.circular(10),
        )),
      ),
    );
  }
}
