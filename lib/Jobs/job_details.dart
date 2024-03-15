// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:job_portal/Jobs/jobs_screen.dart';
//
// class JobDetailsScreen extends StatefulWidget {
//   final String uploadedBy;
//   final String jobId;
//
//   const JobDetailsScreen({
//     required this.uploadedBy,
//     required this.jobId,
//   });
//
//   @override
//   State<JobDetailsScreen> createState() => _JobDetailsScreenState();
// }
//
// class _JobDetailsScreenState extends State<JobDetailsScreen> {
//   String? authorName;
//   String? userImageUrl;
//   String? jobTitle;
//   String? locationCompany = '';
//   Timestamp? postedDateTimeStamp;
//   Timestamp? deadlineDateTimeStamp;
// // add another
//   String? jobCategory;
//   String? jobDescription;
//   bool? recruitment;
//   String? postedDate;
//   String? deadlineDate;
//   String? emailCompany = '';
//   int? applicants = 0;
//   bool isDeadlineAvailable = false;
//   Future<void> getJobData() async {
//     final userDoc = await FirebaseFirestore.instance
//         .collection('user')
//         .doc(widget.uploadedBy)
//         .get();
//     if (userDoc.exists) {
//       setState(() {
//         authorName = userDoc.get('name');
//         userImageUrl = userDoc.get('userImage');
//       });
//     }
//
//     final jobDatabase = await FirebaseFirestore.instance
//         .collection('jobs')
//         .doc(widget.jobId)
//         .get();
//     if (jobDatabase.exists) {
//       setState(() {
//         jobTitle = jobDatabase.get('jobTitle');
//         locationCompany = jobDatabase.get('location');
//         postedDateTimeStamp = jobDatabase.get('createdAt');
//         deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
//         jobTitle = jobDatabase.get('jobTitle');
//         jobDescription = jobDatabase.get('jobDescription');
//         recruitment = jobDatabase.get('recruitment');
//         emailCompany = jobDatabase.get('email');
//         locationCompany = jobDatabase.get('location');
//         applicants = jobDatabase.get('applicants');
//         deadlineDate = jobDatabase.get('deadlineDate');
//         jobCategory = jobDatabase.get('jobCategory');
//         if (postedDateTimeStamp != null) {
//           var postDate = postedDateTimeStamp!.toDate();
//           postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
//         }
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getJobData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//           leading: IconButton(
//             icon: const Icon(
//               Icons.close,
//               size: 40,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => JobScreen()),
//               );
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(4.0),
//                 child: Card(
//                   color: Colors.black54,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 4),
//                           child: Text(
//                             jobTitle ?? '',
//                             maxLines: 3,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 30,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 60,
//                               width: 60,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 3,
//                                   color: Colors.grey,
//                                 ),
//                                 shape: BoxShape.rectangle,
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                     userImageUrl ??
//                                         "https://cdn.pixabay.com/photo/2013/07/13/13/38/man-161282_960_720.png",
//                                   ),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     authorName ?? '',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     locationCompany ?? '',
//                                     style: const TextStyle(
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/Jobs/jobs_screen.dart';

import '../Services/global_method.dart';

class JobDetailsScreen extends StatefulWidget {
  // const JobDetailsScreen({super.key});
  final String uploadedBy;
  final String jobId;
  const JobDetailsScreen({
    required this.uploadedBy,
    required this.jobId,
  });
  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimestamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int? applicants = 0;
  bool isDeadlineAvailable = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uploadedBy)
        .get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .get();
    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        print(jobDatabase.data());
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        // postedDateTimeStamp = jobDatabase.get('postedDateTimeStamp');
        deadlineDateTimestamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadlineDate');
        jobCategory = jobDatabase.get('jobCategory');
        if (postedDateTimeStamp != null) {
          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
        }
      });
      var date = deadlineDateTimestamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(
          thickness: 1,
          color: Colors.white,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => JobScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            jobTitle == null ? '' : jobTitle!,
                            maxLines: 3,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? "https://cdn.pixabay.com/photo/2013/07/13/13/38/man-161282_960_720.png"
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null ? "" : authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Applicants",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.how_to_reg_sharp,
                              color: Colors.white,
                            )
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid !=
                                widget.uploadedBy
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dividerWidget(),
                                  const Text(
                                    "Recruitment",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if (_uid == widget.uploadedBy) {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection("jobs")
                                                  .doc(widget.jobId)
                                                  .update({
                                                'recruitment': true,
                                              });
                                            } catch (e) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      "Action cannot be performed",
                                                  context: context);
                                            }
                                          } else {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "You cannot be performed this actions",
                                                context: context);
                                          }
                                          getJobData();
                                        },
                                        child: const Text(
                                          "ON",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: recruitment == true ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      TextButton(
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if (_uid == widget.uploadedBy) {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection("jobs")
                                                  .doc(widget.jobId)
                                                  .update({
                                                'recruitment': false,
                                              });
                                            } catch (e) {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      "Action cannot be performed",
                                                  context: context);
                                            }
                                          } else {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "You cannot be performed this actions",
                                                context: context);
                                          }
                                          getJobData();
                                        },
                                        child: const Text(
                                          "OFF",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: recruitment == false ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
