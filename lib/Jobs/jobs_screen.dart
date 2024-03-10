// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:job_portal/Jobs/search_job.dart';
// import 'package:job_portal/widgets/bottom_nav_bar.dart';
// import 'package:job_portal/widgets/job_widget.dart';
//
// import '../Persistent/persistent.dart';
//
// class JobScreen extends StatefulWidget {
//   const JobScreen({super.key});
//
//   @override
//   State<JobScreen> createState() => _JobScreenState();
// }
//
// class _JobScreenState extends State<JobScreen> {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   // String? jobCategoryFilter = '';
//   String? jobCategoryFilter;
//
//   _showCategoriesDialog({required Size size}) {
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           backgroundColor: Colors.black54,
//           title: const Text(
//             'Job Category',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 20, color: Colors.white),
//           ),
//           content: Container(
//             width: size.width * 0.9,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: Persistent.jobCategoryList.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       jobCategoryFilter = Persistent.jobCategoryList[index];
//                     });
//
//                     Navigator.canPop(context) ? Navigator.pop(context) : null;
//                     print(
//                         'jobCategoryList[index],${Persistent.jobCategoryList[index]}');
//                   },
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.arrow_right_alt_outlined,
//                         color: Colors.grey,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           Persistent.jobCategoryList[index],
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.canPop(context) ? Navigator.pop(context) : null;
//                 },
//                 child: Text(
//                   'Close',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 )),
//             TextButton(
//                 onPressed: () {
//                   setState(() {
//                     jobCategoryFilter = null;
//                   });
//                   Navigator.canPop(context) ? Navigator.pop(context) : null;
//                 },
//                 child: Text(
//                   'Cancel Filter',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 )),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.deepOrange.shade300, Colors.blueAccent],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           stops: const [0.2, 0.9],
//         ),
//       ),
//       child: Scaffold(
//         bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.deepOrange.shade300, Colors.blueAccent],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 stops: const [0.2, 0.9],
//               ),
//             ),
//           ),
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             icon: Icon(
//               Icons.filter_list_rounded,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               _showCategoriesDialog(size: size);
//             },
//           ),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (c) => SearchScreen()));
//                 },
//                 icon: Icon(
//                   Icons.search_outlined,
//                   color: Colors.black,
//                 ))
//           ],
//         ),
//         body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//           stream: FirebaseFirestore.instance
//               .collection('jobs')
//               .where('jobCategory', isEqualTo: jobCategoryFilter)
//               .where('recruitment', isEqualTo: true)
//               .orderBy('createdAt', descending: false)
//               .snapshots(),
//           builder: (context,
//               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.connectionState == ConnectionState.active) {
//               if (snapshot.hasError) {
//                 // Print error details to the console
//                 print('StreamBuilder Error: ${snapshot.error}');
//                 return Center(
//                   child: Text(
//                     'Error: ${snapshot.error}',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//                   ),
//                 );
//               }
//               if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: Text('There are no jobs'),
//                 );
//               }
//               // Debug print to check the number of documents retrieved
//               print('Number of documents: ${snapshot.data!.docs.length}');
//               // Debug print to log the data retrieved from Firestore
//               // Iterate through each document to print document data
//               for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                 print('Document ${i + 1}: ${snapshot.data!.docs[i].data()}');
//               }
//               return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return JobWidget(
//                     jobTitle: snapshot.data!.docs[index]['jobTitle'],
//                     jobDescription: snapshot.data!.docs[index]
//                         ['jobDescription'],
//                     jobId: snapshot.data!.docs[index]['jobId'],
//                     uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
//                     userImage: snapshot.data!.docs[index]['userImage'],
//                     name: snapshot.data!.docs[index]['name'],
//                     recruitment: snapshot.data!.docs[index]['recruitment'],
//                     email: snapshot.data!.docs[index]['email'],
//                     location: snapshot.data!.docs[index]['location'],
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               // Handle error state
//               return Center(
//                 child: Text(
//                   'Error: ${snapshot.error}',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//                 ),
//               );
//             }
//             // Return a default error message if none of the above conditions are met
//             return Center(
//               child: Text(
//                 'Something went wrong',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/Jobs/search_job.dart';
import 'package:job_portal/widgets/bottom_nav_bar.dart';
import 'package:job_portal/widgets/job_widget.dart';

import '../Persistent/persistent.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({Key? key}) : super(key: key);

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? jobCategoryFilter;

  _showCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text(
            'Job Category',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      jobCategoryFilter = Persistent.jobCategoryList[index];
                    });
                    Navigator.pop(context); // Close dialog
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Persistent.jobCategoryList[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  jobCategoryFilter = null; // Clear filter
                });
                Navigator.pop(context); // Close dialog
              },
              child: Text(
                'Cancel Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _showCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (c) => SearchScreen()),
                );
              },
              icon: Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: (jobCategoryFilter == null)
              ? FirebaseFirestore.instance
                  .collection('jobs')
                  .where('recruitment', isEqualTo: true)
                  .orderBy('createdAt', descending: false)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('jobs')
                  .where('jobCategory', isEqualTo: jobCategoryFilter)
                  .where('recruitment', isEqualTo: true)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty ||
                snapshot.hasError) {
              if (snapshot.hasError) {
                // Handle error state
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                );
              }
              // Return a default error message if none of the above conditions are met
              return Center(
                child: Text(
                  'No jobs found.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return JobWidget(
                    jobTitle: snapshot.data!.docs[index]['jobTitle'],
                    jobDescription: snapshot.data!.docs[index]
                        ['jobDescription'],
                    jobId: snapshot.data!.docs[index]['jobId'],
                    uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                    userImage: snapshot.data!.docs[index]['userImage'],
                    name: snapshot.data!.docs[index]['name'],
                    recruitment: snapshot.data!.docs[index]['recruitment'],
                    email: snapshot.data!.docs[index]['email'],
                    location: snapshot.data!.docs[index]['location'],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
