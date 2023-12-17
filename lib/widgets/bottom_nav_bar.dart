import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/Jobs/jobs_screen.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  final int indexNum;
  BottomNavigationBarForApp({required this.indexNum});
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade500,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      index: indexNum,
      items: [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.black,
        )
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => JobScreen()),
          );
        }
      },
    );
  }
}
