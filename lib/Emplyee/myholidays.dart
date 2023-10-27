// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable, unused_element, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MYholidays extends StatefulWidget {
  const MYholidays({Key? key}) : super(key: key);

  @override
  MYholidaysState createState() => MYholidaysState();
}

class MYholidaysState extends State<MYholidays> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff453658),
        title: Text(
          'MY Holidays',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('holiday_requests')
            .where('user_uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Center(
              child: Text(
                'No holidays yet.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic>? data =
                    documents[index].data() as Map<String, dynamic>?;
                var status = data?['approved'];
                var date = data?["date"];
                var reason = data?["reason"];
                // var status = data?["status"];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: data?["status"] == 1 ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'ID:${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: $date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      if (status == 0)
                        Text('Status: Not Approved')
                      else if (status == 1)
                        Text('Status:Approved')
                      else if (status == 2)
                        Text('Status: Rejected'),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Reason: $reason'),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
