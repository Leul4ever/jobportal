//import 'dart:html';

import 'package:animated_text_kit/animated_text_kit.dart';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/Employers_account/emp_verify.dart';
import 'package:project1/Employers/home_page/emp_home_page.dart';

import 'empUtils.dart';
import 'emp_forgote_account.dart';

class EmpLoginWidget extends StatefulWidget {
  final VoidCallback onclickedSignIn;
  const EmpLoginWidget({
    Key? key,
    required this.onclickedSignIn,
  }) : super(key: key);

  @override
  State<EmpLoginWidget> createState() => _EmpLoginWidgetState();
}

class _EmpLoginWidgetState extends State<EmpLoginWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await checkUserRole(user.uid);
        if (isEmployer) {
          Navigator.pushNamed(context, EmpHomePage.routeName);
        } else {
          EmpUtils.showSnackBar('Job seeker not found', Colors.red);
          FirebaseAuth.instance.signOut();
        }
      }
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final companyNameController = TextEditingController();
  final taxIdController = TextEditingController();

  bool isEmployer = false;
  Future<void> checkUserRole(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('employer')
        .doc(user.uid)
        .get();
    if (userData.exists) {
      String role = userData.get('role');
      setState(() {
        isEmployer = role == 'employer';
      });
    }
    //return isJobSeeker;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _showProgressIndicator = false;
  Future signIn() async {
    setState(() {
      _showProgressIndicator = true;
    });
    Visibility(
      visible: _showProgressIndicator,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //         ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.pushNamed(context, VerifyEmpEmail.routeName);
    } on FirebaseAuthException catch (e) {
      EmpUtils.showSnackBar(e.message, Colors.red);
      print(e.message);
    }
    setState(() {
      _showProgressIndicator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employer Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: (MediaQuery.of(context).size.width) * 3 / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Welcome back!',
                          textStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w500,
                          ),
                          speed: const Duration(
                            milliseconds: 450,
                          )),
                    ],
                    isRepeatingAnimation: true,
                    totalRepeatCount: 4,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      label: Text('password'),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // command design pattern
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50)),
                      onPressed: signIn,
                      icon: Icon(Icons.login),
                      label: Text('Sign in')),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                      child: const Text(
                        'forgote password',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromARGB(255, 255, 7, 172)),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotePassword()))),
                  SizedBox(
                    height: 24,
                  ),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: 'No accont ?  ',
                          children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onclickedSignIn,
                            text: 'Sign up',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline))
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
