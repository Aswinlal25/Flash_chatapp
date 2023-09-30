// import 'package:chat_app/screens/auth/account_creation.dart';
// import 'package:flutter/material.dart';
// import 'package:chat_app/screens/auth/Methods.dart';

// import '../home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 43, 42, 42),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 140),
//               Text(
//                 'Welcome to',
//                 style: TextStyle(fontSize: 35, color: Colors.white),
//               ),
//               Text(
//                 'FLASH',
//                 style: TextStyle(
//                     fontSize: 36,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w100),
//               ),
//               Text(
//                 ' Login to Continue !',
//                 style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w400),
//               ),
//               SizedBox(height: 100),

//               Container(
//                 width: 330,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: Colors.white,
//                 ),
//                 child: TextField(
//                    controller: _email,
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     hintStyle: TextStyle(
//                         color: Colors.black, letterSpacing: 2, fontSize: 15),
//                     prefixIcon:
//                         Icon(Icons.email, color: Colors.black, size: 20),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                           25),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),

//               SizedBox(height: 20),

//               Container(
//                 width: 330,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: Colors.white,
//                 ),
//                 child: TextField(
//                    controller: _password,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     hintStyle: TextStyle(
//                         color: Colors.black, letterSpacing: 2, fontSize: 15),
//                     prefixIcon: Icon(Icons.lock, color: Colors.black, size: 20),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                           25),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   style: TextStyle(color: Colors.black),
//                   obscureText: true,
//                 ),
//               ),

//               SizedBox(height: 100),

//               // Login Button
//               Padding(
//                 padding: const EdgeInsets.only(left: 93),
//                 child: ElevatedButton(
//                   onPressed: () {

//                     if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
//                       setState(() {
//                         isLoading = true;
//                       });
                      // logIn(_email.text, _password.text).then((user) {
                      //   if (user != null) {
                      //     print('Login Sucessful');
                      //     setState(() {
                      //       isLoading = false;
                      //     });
                      //     Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => HomeScreen()));
                      //   } else {
                      //     print('Login Failed');
                      //     setState(() {
                      //       isLoading = false;
                      //     });
                      //   }
                      // });
//                     } else {
//                       print('Please fill form correctly');
//                     }
//                   },
//                   child: Text(
//                     'Login',
//                     style: TextStyle(fontSize: 16, letterSpacing: 1.5),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     // ignore: deprecated_member_use
//                     primary: Color.fromARGB(
//                         255, 2, 87, 157), // Button background color
//                     // ignore: deprecated_member_use
//                     onPrimary: Colors.white, // Text color
//                     minimumSize: Size(150, 52), // Button size
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30), // Button shape
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 8,
//               ),

//               // Navigation to another screen when "Create Account" is tapped
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AccountCreateScreen()));
//                   // Navigate to another screen here
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 126),
//                   child: Text(
//                     'Create Account',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../apis/api.dart';
import '../home_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/2.jpeg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(  32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:  100),
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
                    color: Colors.white.withOpacity(0.8), // Add opacity to the white color
                  ),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: Colors.black, letterSpacing: 2, fontSize: 15),
                      prefixIcon: Icon(Icons.email, color: Colors.black, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8), // Add opacity
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
                    color: Colors.white.withOpacity(0.8), // Add opacity
                  ),
                  child: TextField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.black, letterSpacing: 2, fontSize: 15),
                      prefixIcon: Icon(Icons.lock, color: Colors.black, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8), // Add opacity
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.only(left: 93),
                  child: ElevatedButton(
                    onPressed: () {

                    //   final email = _email.text.trim();
                    // final password = _password.text.trim();

                      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        showProgressBar(context);
                        // Simulate login by delaying for 2 seconds
                        Future.delayed(Duration(seconds: 2), () {
                          if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            logIn(_email.text, _password.text).then((user) async {
                              if (user != null) {
                                print('Login Successful');
                                setState(() {
                                  isLoading = false;
                                });
                                if((await APIs.userExists())){
                                   Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => HomeScreen()));
                                _showSnackBar(context, 'Login Successful!', Colors.black);
                                }else{
                                  await APIs.createUser().then((value){
                                    Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => HomeScreen()));
                                _showSnackBar(context, 'Login Successful!', Colors.black);
                                  });
                                }
                               
                              } else {
                                print('Login Failed');
                                setState(() {
                                  isLoading = false;
                                });
                                _showSnackBar(context, 'Login Failed. Please try again.', Colors.amber);
                              }
                            });
                          }
                        });
                      } else {
                        print('Please fill out the form correctly');
                        _showSnackBar(context, 'Please fill out the form correctly.', Colors.black);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, letterSpacing: 1.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 2, 87, 157),
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
                    padding: const EdgeInsets.only(left: 126),
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(height: 208,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
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

  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_)=> Center(child: CircularProgressIndicator(),));
  }
}
