import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/provider/car_provider.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/view/Home/Bottom%20Nav%20Bar/description_page.dart';
import 'package:flutter_application_1/view/Home/Bottom%20Nav%20Bar/home_page.dart';
import 'package:flutter_application_1/view/Home/bottom_navbar.dart';

import 'package:flutter_application_1/view/user%20login/login.dart';
import 'package:flutter_application_1/view/user%20login/mobile_no_otp.dart';
import 'package:flutter_application_1/view/user%20login/sign_up.dart';
import 'package:flutter_application_1/view/user_edit.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;
  @override
  void initState() {
    readValueToSharedPreference();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CarProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          inputDecorationTheme:
              InputDecorationTheme(errorStyle: TextStyle(color: Colors.orange)),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: isUserLoggedIn ? BottomNavBar() : Login(),

        home: DescriptionPage(),
      ),
    );
  }

  readValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isUserLoggedIn = prefs.getBool('isLogin') ?? false;
    setState(() {
      isUserLoggedIn;
    });
  }
  // appExitShowDialog(BuildContext context, UserProvider userProvider) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Exit'),
  //         content: Text('Are you sure you want to Exit?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {

  //               SystemNavigator.pop();

  //               // Perform delete operation here
  //               // Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Yes'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('No'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
