// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable, unused_element, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class holidaysRequests extends StatefulWidget {
  const holidaysRequests({Key? key}) : super(key: key);

  @override
  holidaysRequestsState createState() => holidaysRequestsState();
}

class holidaysRequestsState extends State<holidaysRequests> {
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
          'Holiday Request',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('holiday_requests')
            .where('approved', isNotEqualTo: 2)
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
                'No requests yet.',
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
                      Text('Reason: $reason'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          status == 1
                              ? ElevatedButton(
                                  onPressed: () async {
                                    setState(() {});
                                  },
                                  child: Text('Accepted'),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("holiday_requests")
                                        .doc(documents[index].id)
                                        .update({"approved": 1});
                                    setState(() {});
                                  },
                                  child: Text('Accept'),
                                ),
                          SizedBox(width: 8),
                          status != 2 && status != 1
                              ? ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("holiday_requests")
                                        .doc(documents[index].id)
                                        .update({"approved": 2});
                                  },
                                  child: Text('Reject'),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
