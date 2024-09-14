import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/custom_button.dart';
import 'package:flutter_application_1/shared/custom_textform.dart';
import 'package:flutter_application_1/view/user%20login/otp.dart';

class MobileNoOTP extends StatefulWidget {
  const MobileNoOTP({super.key});

  @override
  State<MobileNoOTP> createState() => _MobileNoOTPState();
}

class _MobileNoOTPState extends State<MobileNoOTP> {
  String? phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 20),
              child: Text(
                "Forget Password",
                style: TextStyle(fontSize: 32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Text(
                "Recover Password",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 2),
              child: CustomTextFormField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                hintText: " Mobile Number",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: CustomButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+977$phoneNumber',
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTP(
                                verificationId: verificationId,
                              ),
                            ));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  child: Text("Recover")),
            )
          ],
        ),
      )),
    );
  }
}
