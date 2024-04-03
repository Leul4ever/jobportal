import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/widgets/bottom_nav_bar.dart';

import '../widgets/all_companies_widget.dart';

class AllWorkerScreen extends StatefulWidget {
  const AllWorkerScreen({Key? key}) : super(key: key);

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  String searchQuery = '';
  TextEditingController _searchQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(() {
      updateSearchQuery(_searchQueryController.text);
    });
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
        hintText: 'Search for companies...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _searchQueryController.clear();
        },
      )
    ];
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
              // .collection("user")
              // .where("name", isGreaterThanOrEqualTo: searchQuery)
              // .where("name", isLessThanOrEqualTo: searchQuery + '\uf8ff')
              // .snapshots(),
              .collection("user")
              .orderBy("name",
                  descending: false) // Sort by name in ascending order
              .startAt([
            searchQuery.toUpperCase()
          ]) // Start at the provided search query in uppercase
              .endAt([
            searchQuery.toLowerCase() + '\uf8ff'
          ]) // End at the provided search query in lowercase
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              );
            } else {
              final companies = snapshot.data!.docs;
              if (companies.isNotEmpty) {
                return ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AllWorkersWidget(
                      userId: companies[index]['id'],
                      userName: companies[index]['name'],
                      userEmail: companies[index]['email'],
                      phoneNumber: companies[index]['phoneNumber'],
                      userImageUrl: companies[index]['userImage'],
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "No companies found",
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
