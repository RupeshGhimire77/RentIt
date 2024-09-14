import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/helper.dart';
import 'package:flutter_application_1/Utils/status_util.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/view/user%20login/change_password.dart';
import 'package:flutter_application_1/view/Home/home_page.dart';
import 'package:flutter_application_1/view/user%20login/mobile_no_otp.dart';
import 'package:flutter_application_1/view/user%20login/sign_up.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../Utils/string_const.dart';
import '../../shared/custom_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        var provider = Provider.of<UserProvider>(context, listen: false);
        provider.readRememberMe();
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF771616),
      body: SafeArea(
          child: Consumer<UserProvider>(
        builder: (context, userProvider, child) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 30),
                  child: Center(
                    child: Text(
                      signInToYourAccountStr,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                CustomTextFormField(
                  controller: userProvider.emailTextField,
                  onChanged: (p0) => userProvider.setEmail(p0),
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return emailValidationStr;
                    }
                    RegExp regExp = RegExp(emailRegexPatternStr);
                    if (!regExp.hasMatch(p0)) {
                      return validEmailAddrStr;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email),
                  hintText: emailStr,
                  fillColor: Colors.white,
                ),
                CustomTextFormField(
                  controller: userProvider.passwordTextField,
                  onChanged: (p0) => userProvider.setPassword(p0),
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return passwordValidationStr;
                    } else if (p0.length < 8) {
                      return passwordLengthValidationStr;
                    }
                    return null;
                  },
                  hintText: passwordStr,
                  obscureText: !userProvider.showPassword,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          userProvider.showPassword =
                              !userProvider.showPassword;
                        });
                      },
                      icon: userProvider.showPassword
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          // overlayColor: Color(0xff123671),
                          activeColor: Colors.white,
                          checkColor: Color(0xff771616),
                          value: userProvider.checkRemeberMe,
                          onChanged: (value) {
                            userProvider.rememberMe(value);
                            userProvider.isCheckedStatus(value);
                          },
                        ),
                      ),
                      Text(
                        rememberMeStr,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MobileNoOTP(),
                              )),
                          child: Text(
                            forgotPasswordStr,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await userProvider.loginUser();
                        if (userProvider.getLoginUserStatus ==
                            StatusUtil.success) {
                          if (userProvider.isUserExist) {
                            await Helper.displaySnackBar(
                                context, loginSuccessStr);
                            await userProvider.storeValueToSharedPreference();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                                (route) => false);
                          } else {
                            await Helper.displaySnackBar(
                                context, userDoesntExiststr);
                          }
                        } else {
                          Helper.displaySnackBar(
                              context, invalidCredentialsStr);
                        }
                      } else if (userProvider.getLoginUserStatus ==
                          StatusUtil.error) {
                        Helper.displaySnackBar(context, loginFailedStr);
                      }
                    },
                    child: userProvider.getLoginUserStatus == StatusUtil.loading
                        ? CircularProgressIndicator()
                        : Text(
                            signInStr,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dontHaveAnAccountStr,
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              )),
                          child: Text(
                            signUpStr,
                            style: TextStyle(color: Colors.blue),
                          )),
                    )
                  ],
                ),
                userProvider.isSignedInGoogle
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          googleLogin();
                        },
                        child: Text("Google"))
              ],
            ),
          ),
        ),
      )),
    );
  }

  googleLogin() async {
    UserProvider userProvider = UserProvider();
    userProvider.isSignedInGoogle = true;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
        print(e);
      }
    }

    print(user);
    String? token = await user?.getIdToken();
    if (token != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false);
    }
  }
}
