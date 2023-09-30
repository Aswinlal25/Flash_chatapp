//import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/splash_screen.dart';

//import 'screens/auth/login_screen.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              fontSize: 20),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
