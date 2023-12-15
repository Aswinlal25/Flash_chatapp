import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/hive_database/hive_model/user.dart';
import 'package:chat_app/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Hive
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  // open the HiveBox
  Hive.openBox<UserModel>('user_db');

  // initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         useMaterial3: false,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              fontSize: 20),
          iconTheme: IconThemeData(
            color: white,
          ),
          // backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: Colors.white),
      ),
      home: SplashScreen(),
    );
  }
}
