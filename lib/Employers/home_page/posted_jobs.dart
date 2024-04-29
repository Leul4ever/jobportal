import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/Employers/home_page/appliers.dart';

import '../models/jobs_model.dart';

class Posted_jobs extends StatefulWidget {
  static const routeName = 'Posted_jobs';
  @override
  _Posted_jobsState createState() => _Posted_jobsState();
}

class _Posted_jobsState extends State<Posted_jobs> {
  String? currentUser;
  Future<String> getCurrentUserUid() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('Curent user id ${user}');
      return user.uid;
    } else {
      return '';
    }
  }

  void getUserUid() async {
    try {
      currentUser = await getCurrentUserUid();
      print('the current user is  ${currentUser.toString()}');
      if (currentUser != null) {
        print('the current user is not null');
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    print('the document pathe is ${currentUser}');
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: StreamBuilder<QuerySnapshot>(
        stream:
            //FirebaseFirestore.instance
            // .collection('employer')
            // .doc(getCurrentUserUid())
            // .collection('job posting')
            // .snapshots(),
            FirebaseFirestore.instance
                .collection('employer')
                .doc(currentUser)
                .collection('job posting')
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          if (!snapshot.hasData) return Text('OOPS there is no posted jobs');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Text('Loading...'));

            default:
              return SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 600,
                    child: new ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: new ListTile(
                              shape: RoundedRectangleBorder(
                                // side: BorderSide(color: Colors.blue, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              style: ListTileStyle.drawer,
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              //  leading: new Text(document['job category']),
                              title: new Text(
                                document['title'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  width: 20,
                                  child: Row(
                                    children: [
                                      new Text(document['job category']),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      new Text(document['employment type']),
                                    ],
                                  )),
                              trailing: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Appliers(
                                            jobId: document['job id'],
                                          )),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Text(
                                    'View Appliers',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                  width: 100,
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
