import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/global_variables.dart';

class Persistent {
  static List<String> jobCategoryList = [
    'Architecture and Construction',
    'Education and Training',
    'Development-Programming',
    'Business & Management',
    'Information Technology',
    'Human Resource ',
    'Marketing and sales',
    'Design and Architecture',
    "Arts & Design",
    "Accounting & Finance",
    "Healthcare & Medicine",
    "Law & Legal",
    "Science & Mathematics",
    "Social Sciences",
    "Writing & Translation",
    "Education & Teaching",
  ];
  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    name = userDoc.get('name');
    userImage = userDoc.get('userImage');
    location = userDoc.get('location');
  }
}
