import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/string_const.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/view/user%20login/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user1 = FirebaseAuth.instance.currentUser;

    // Fallback to email if displayName is null
    String displayName = user1?.displayName ?? user1?.email ?? "User";
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color(0xFF771616),
          leading: Padding(
            padding: const EdgeInsets.only(top: 8, left: 20),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/Jackie-Chan.jpeg"),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              displayName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 8),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_active,
                    size: 27.5,
                  )),
            )
          ],
        ),
        body: Stack(
          children: [
            CustomButton(
                onPressed: () {
                  logout();
                  signOut();
                },
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLogin");
    await Helper.displaySnackBar(context, logoutSuccessfullStr);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }

  signOut() async {
    FirebaseAuth.instance.signOut();
    if (GoogleSignIn().currentUser != null) {
      await GoogleSignIn().signOut();
    }

    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      Helper.displaySnackBar(context, "Failed to disconnect on SignOut.");
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (route) => false);
  }
}
