import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_portal/Services/global_method.dart';
import 'package:uuid/uuid.dart';

import '../Persistent/persistent.dart';
import '../Services/global_variables.dart';
import '../widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  TextEditingController _jobCategoryContoller =
      TextEditingController(text: 'Select Job Category');
  TextEditingController _jobTitleContoller = TextEditingController();
  TextEditingController _jobDescriptionContoller = TextEditingController();
  TextEditingController _deadlineDateContoller =
      TextEditingController(text: 'Job Deadline Date');

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadLineDateTimeStamp;
  bool _isLoading = false;
  Widget _textTitle({required String label}) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fet,
    required int maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          fet();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is Missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'JobDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
        ),
      ),
    );
  }

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
                      _jobDescriptionContoller.text =
                          Persistent.jobCategoryList[index];
                    });
                    Navigator.pop(context);
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
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ))
          ],
        );
      },
    );
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadlineDateContoller.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
        deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_deadlineDateContoller.text == 'choose job Deadline Date' ||
          _jobCategoryContoller.text == 'choose Job Category') {
        GlobalMethod.showErrorDialog(
            error: 'Please pick every thing ', context: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
          'jobId': jobId,
          'uploadedBy': _uid,
          'email': user.email,
          'jobTitle': _jobTitleContoller.text,
          'jobDescription': _jobDescriptionContoller.text,
          'deadlineDate': _deadlineDateContoller.text,
          'deadlineDateTimeStamp': deadLineDateTimeStamp,
          'jobCategory': _jobCategoryContoller.text,
          'jobComment': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _jobCategoryContoller.clear();
        _jobDescriptionContoller.clear();
        setState(() {
          _jobCategoryContoller.text = 'Choose job category';
          _deadlineDateContoller.text = 'Choose job Deadline date';
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
          GlobalMethod.showErrorDialog(
              error: error.toString(), context: context);
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('is not valid');
    }
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Signatra'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitle(label: 'Job Category:'),
                            _textFormFields(
                                valueKey: 'JobCategory',
                                controller: _jobCategoryContoller,
                                enabled: false,
                                fet: () {
                                  _showCategoriesDialog(
                                    size: size,
                                  );
                                },
                                maxLength: 100),
                            _textTitle(label: 'Job Title:'),
                            _textFormFields(
                                valueKey: 'JobTitle',
                                controller: _jobTitleContoller,
                                enabled: true,
                                fet: () {},
                                maxLength: 100),
                            _textTitle(label: 'Job Description:'),
                            _textFormFields(
                                valueKey: 'JobDescription',
                                controller: _jobDescriptionContoller,
                                enabled: true,
                                fet: () {},
                                maxLength: 100),
                            _textTitle(label: 'Job Deadline Date:'),
                            _textFormFields(
                                valueKey: 'Deadline',
                                controller: _deadlineDateContoller,
                                enabled: false,
                                fet: () {
                                  _pickDateDialog();
                                },
                                maxLength: 100)
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _uploadTask();
                                },
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Post Now',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            fontFamily: 'Signatra'),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Icon(
                                        Icons.upload_file,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
