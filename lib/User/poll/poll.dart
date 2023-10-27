// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Userpolls extends StatefulWidget {
  @override
  _UserpollsState createState() => _UserpollsState();
}

class _UserpollsState extends State<Userpolls> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getLatestDocument() async {
    try {
      QuerySnapshot snapshot =
          await firestore.collection('your_collection').get();

      if (snapshot.docs.isEmpty) {
        return null; // No documents found
      }

      // Sort the documents by date in descending order (latest first)
      snapshot.docs.sort((a, b) {
        DateTime dateA = a['date'] as DateTime;
        DateTime dateB = b['date'] as DateTime;
        return dateB.compareTo(dateA);
      });

      // The latest document is now the first in the sorted list
      DocumentSnapshot latestDocument = snapshot.docs.first;
      return latestDocument;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Latest Document')),
      body: Center(
        child: FutureBuilder<DocumentSnapshot?>(
          future: getLatestDocument(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error fetching data.');
            } else {
              DocumentSnapshot? latestDocument = snapshot.data;
              if (latestDocument == null) {
                return Text('No documents available.');
              } else {
                // Access the data from the latest document
                Map<String, dynamic> data =
                    latestDocument.data() as Map<String, dynamic>;
                return Text('Latest Date: ${data['date']}');
              }
            }
          },
        ),
      ),
    );
  }
}
