import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/user_account/utils.dart';
import '../bridgeTOemp_home_page.dart';
import 'emp_auth_page.dart';

class VerifyEmpEmail extends StatefulWidget {
  static const routeName = '/VerifyEmpEmail';
  const VerifyEmpEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmpEmail> createState() => _VerifyEmpEmailState();
}

class _VerifyEmpEmailState extends State<VerifyEmpEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        canResendEmail = true;
      });
      timer = Timer.periodic(
        Duration(seconds: 3),
        (Timer) => chekEmailVerified(),
      );
    } catch (e) {
      Utils.showSnackBar(context, e.toString(), Colors.red);
    }
  }

  Future chekEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? Emp_home()
        : Scaffold(
            appBar: AppBar(
              title: Text('Verify Email'),
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A verification email has been sent to your account',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50)),
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      icon: Icon(Icons.mail),
                      label: Text('Resend')),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50)),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    // icon: Icon(Icons.mail),
                    // label: Text('Resend')
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
