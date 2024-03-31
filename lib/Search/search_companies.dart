import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/widgets/bottom_nav_bar.dart';

import '../widgets/all_companies_widget.dart';

class AllWorkerScreen extends StatefulWidget {
  const AllWorkerScreen({super.key});

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // title: const Text('All Workers Screen'),
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

          automaticallyImplyLeading: false,
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user")
              .where("name", isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AllWorkersWidget(
                        userId: snapshot.data!.docs[index]['id'],
                        userName: snapshot.data!.docs[index]['name'],
                        userEmail: snapshot.data!.docs[index]['email'],
                        phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                        userImageUrl: snapshot.data!.docs[index]['userImage'],
                      );
                    });
              } else {
                return const Center(
                  child: Text(
                    "There is no users",
                  ),
                );
              }
            }
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
