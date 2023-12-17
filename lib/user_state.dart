import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/Jobs/jobs_screen.dart';
import 'package:job_portal/LoginPage/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null) {
          // User is not logged in yet
          print('User is not logged in yet');
          return Login();
        } else if (userSnapshot.hasData) {
          // User is logged in
          print('User already logged in');
          return JobScreen();
        } else if (userSnapshot.hasError) {
          // An error occurred
          return Scaffold(
            body: Center(
              child: Text('An error occurred, try again later'),
            ),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          // Still waiting for the initial authentication state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Default case, something went wrong
        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}
