import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/user_state.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs Screen'),
      ),
      body: ElevatedButton(
        onPressed: () {
          _auth.signOut();
          Navigator.canPop(context) ? Navigator.pop(context) : null;

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UserState()));
        },
        child: Text('Logout'),
      ),
    );
  }
}
