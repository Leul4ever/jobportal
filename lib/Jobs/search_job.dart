import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/widgets/job_widget.dart';

import 'jobs_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = 'Search query';
  TextEditingController _searchQueryController = TextEditingController();
  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for jobs ...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _clearSearchQuery();
        },
      )
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
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
              // title: const Text('Search screen'),
              // centerTitle: true,
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
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => JobScreen()));
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: _buildSearchField(),
              actions: _buildActions(),
            ),
            body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
                    .where('recruitment', isEqualTo: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data?.docs.isNotEmpty == true) {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return JobWidget(
                              jobTitle: snapshot.data!.docs[index]['jobTitle'],
                              jobDescription: snapshot.data!.docs[index]
                                  ['jobDescription'],
                              jobId: snapshot.data!.docs[index]['jobId'],
                              uploadedBy: snapshot.data!.docs[index]
                                  ['uploadedBy'],
                              userImage: snapshot.data!.docs[index]
                                  ['userImage'],
                              name: snapshot.data!.docs[index]['name'],
                              recruitment: snapshot.data!.docs[index]
                                  ['recruitment'],
                              email: snapshot.data!.docs[index]['email'],
                              location: snapshot.data!.docs[index]['location'],
                            );
                          });
                    } else {
                      return Center(
                        child: Text(
                            'No job available ,Would you mind exploring other job opportunities?'),
                      );
                    }
                  }
                  return const Center(
                    child: Text(
                      'Some thing went wrong ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  );
                })));
  }
}
