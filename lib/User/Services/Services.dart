// ignore_for_file: prefer_const_constructors, camel_case_types, library_private_types_in_public_api, file_names, deprecated_member_use, avoid_print

import 'package:app/User/Services/payment.dart';
import 'package:app/User/Services/paymnet_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Change_services extends StatefulWidget {
  const Change_services({Key? key}) : super(key: key);

  @override
  _ChangeServicesState createState() => _ChangeServicesState();
}

class _ChangeServicesState extends State<Change_services> {
  String? selectedService = userpayment().service; // Default selected service
  Map<String, Map<String, dynamic>> serviceDetails = {
    'Basic': {'price': 400, 'Quality': '720', 'channels': 100},
    'Gold': {'price': 700, 'Quality': '1080', 'channels': 120},
    'Premium': {'price': 1200, 'Quality': '1280', 'channels': 150},
    // Add more services and their details here
  };
  User? user;
  String? username;
  String? email;
  String? service;
  double? bill;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Retrieve user data from Firestore and set it to `username` and `email`
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          email = data['email'];
          username = data['username'];
          service = data["service"];
          bill = data["bill"];
        });
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });

    // Fetch employee data from Firestore's "salary" collection
    // _fetchEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Service',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff392850),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButton<String>(
                  value: selectedService,
                  onChanged: (newValue) {
                    setState(() {
                      selectedService = newValue!;
                      userpayment().service = selectedService;

                      userpayment().price =
                          serviceDetails[selectedService]!['price'];
                    });
                  },
                  items: serviceDetails.keys.map((service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(
                        service,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (selectedService!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSpecSection(
                    label: 'Price',
                    value: '${serviceDetails[selectedService]!['price']}',
                  ),
                  _buildSpecSection(
                    label: 'Quality',
                    value: serviceDetails[selectedService]!['Quality'],
                  ),
                  _buildSpecSection(
                    label: 'Channels',
                    value:
                        serviceDetails[selectedService]!['channels'].toString(),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Color(0xff392850),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'current service is: $service',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => payment_method()),
                );
                userpayment().service = selectedService;

                userpayment().uid = user!.uid;
                userpayment().price = serviceDetails[selectedService]!['price'];
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff392850),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecSection({required String label, required String value}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
