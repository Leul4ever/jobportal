import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/user_account/verify_email.dart';

class JobSeekerSignUPForm extends StatefulWidget {
  static const routeName = 'JobSeekerSignUPForm';
  const JobSeekerSignUPForm({super.key});

  @override
  State<JobSeekerSignUPForm> createState() => _JobSeekerSignUPFormState();
}

class _JobSeekerSignUPFormState extends State<JobSeekerSignUPForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  bool _isSigningUp = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isSigningUp = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController1.text.trim(),
      );

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(userCredential.user!.uid)
          .set({
        'email': emailController.text,
        'role': 'jobseeker', // Set user role
      });

      // Add personal info
      Map<String, dynamic> personalinfo = {'id': userCredential.user!.uid};
      await FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(userCredential.user!.uid)
          .collection('jobseeker-profile')
          .doc('profile')
          .set({'personal-info': personalinfo});

      // Navigate to VerifyEmail screen
      Navigator.pushNamed(context, VerifyEmail.routeName);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Some problem occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 252, 234, 240),
                label: Text('Email'),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 252, 234, 240)),
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
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController1,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 252, 234, 240),
                label: Text('Password'),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 252, 234, 240)),
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
              validator: (value) => value != null && value.length < 6
                  ? 'Enter at least 6 characters'
                  : null,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController2,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 252, 234, 240),
                label: Text('Verify Password'),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 252, 234, 240)),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the password again';
                }
                if (value.length < 6) {
                  return 'Enter at least 6 characters';
                }
                if (value != passwordController1.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size.fromHeight(70),
              ),
              onPressed: _isSigningUp
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        signUp();
                      }
                    },
              icon: Icon(Icons.person_add, size: 30.0),
              label: _isSigningUp
                  ? CircularProgressIndicator(
                      color: Colors.amber,
                    )
                  : Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
