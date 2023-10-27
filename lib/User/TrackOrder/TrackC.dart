// ignore_for_file: deprecated_member_use, prefer_const_constructors, file_names, library_private_types_in_public_api, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Trackk extends StatefulWidget {
  const Trackk({Key? key}) : super(key: key);

  @override
  _TrackkState createState() => _TrackkState();
}

class _TrackkState extends State<Trackk> {
  TextEditingController complaintNumberController = TextEditingController();
  String complaintStatus = '';
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> checkComplaintStatus() async {
    if (user == null) {
      // Handle the case where the user is not authenticated.
      // You can show an error message or navigate to a login screen.
      return;
    }

    String userId = user!.uid;

    DocumentSnapshot complainDocSnapshot = await FirebaseFirestore.instance
        .collection("complains")
        .doc(userId)
        .get();

    if (complainDocSnapshot.exists) {
      Map<String, dynamic> data =
          complainDocSnapshot.data() as Map<String, dynamic>;

      // Assuming 'status' field exists in your Firestore data
      int? status = data['status'] as int?;

      if (status == 1) {
        complaintStatus = 'In Progress';
      } else if (status == 2) {
        complaintStatus = 'Resolved';
      } else if (status == 0) {
        complaintStatus = 'Not seen yet';
      } else {
        complaintStatus = 'Invalid Complaint Number';
      }
    } else {
      complaintStatus = "No complaint from you";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaint Status',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff392850),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: complaintNumberController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  hintText: 'Enter complaint Id',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                checkComplaintStatus();
                // You can also perform any navigation logic here if needed
              },
              child: Text('Check Status'),
            ),
            SizedBox(height: 16.0),
            complaintStatus.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Complaint Status: $complaintStatus',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff392850),
                      onPrimary: Colors.white,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
