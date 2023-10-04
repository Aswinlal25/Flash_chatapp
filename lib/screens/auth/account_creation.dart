import 'package:flutter/material.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/auth/Methods.dart';
import '../../apis/api.dart';
import '../home_screen.dart';

class AccountCreateScreen extends StatefulWidget {
  const AccountCreateScreen({super.key});

  @override
  State<AccountCreateScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AccountCreateScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 42, 42),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
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
                    ' Create Account to Continue !',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 100),
                  Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Form(
                      child: TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 15),
                          prefixIcon:
                              Icon(Icons.person, color: Colors.black, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2,
                            fontSize: 15),
                        prefixIcon:
                            Icon(Icons.email, color: Colors.black, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }

                        return null; // Return null for valid input
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2,
                            fontSize: 15),
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.black, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(color: Colors.black),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 70),

                  // Login Button
                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement your account creation logic here
                        if (_name.text.isNotEmpty &&
                            _email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          showProgressBar(context);
                          createAccount(_name.text, _email.text, _password.text)
                              .then((user) async {
                            if (user != null) {
                              setState(() {
                                isLoading = false;
                              });

                              if ((await APIs.userExists())) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                                _showSnackBar(
                                    context, 'Login Successful!', Colors.black);
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
                              print('Account Created Successfully');
                              _showSnackBar(
                                  context,
                                  'Account Created Successfully.',
                                  Colors.black);
                            } else {
                              print('Account Creation Failed');
                            }
                          }).catchError((error) {
                            setState(() {
                              isLoading = false;
                            });
                            print('Error creating account: $error');
                          });
                        } else {
                          print('Please enter all fields');
                          _showSnackBar(context, 'Please enter all fields.',
                              Colors.black);
                        }
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 2, 87, 157),
                        onPrimary: Colors.white,
                        minimumSize: Size(180, 52),
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
                              builder: (context) => LoginScreen()));
                      // Navigate to Login screen
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 156),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  )
                ],
              ),
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
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.fixed,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(
              child: CircularProgressIndicator(),
            ));
  }
}
