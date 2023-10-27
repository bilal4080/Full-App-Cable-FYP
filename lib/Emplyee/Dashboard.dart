// ignore_for_file: unnecessary_brace_in_string_interps, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'package:app/Admin/Help/admin_help.dart';
import 'package:app/Emplyee/Work_timing.dart';
import 'package:app/Emplyee/holiday.dart';
import 'package:app/Emplyee/myholidays.dart';
import 'package:app/profile.dart';
import 'package:app/signin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeDashboard extends StatefulWidget {
  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  User? user;
  String? username;
  String? email;

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
        });
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });

    // Fetch employee data from Firestore's "salary" collection
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff453658),
        title: Text(
          'Employee Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff392850),
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xff392850)),
                accountName: Text(
                  username ??
                      "Unknown", // Provide a default value if username is null
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text(email ??
                    ""), // Use the null-aware operator to handle null values
                currentAccountPictureSize: Size.square(100),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.black,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeDashboard()),
                  );
                }
                // Handle Home option tap
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.request_page,
                  color: Colors.black,
                ),
                title: Text(
                  'Holiday Requests',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HolidayRequestScreen()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.holiday_village,
                  color: Colors.black,
                ),
                title: Text(
                  'MY Holiday',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MYholidays()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(
                'profile',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
                // Handle Settings option tap
              },
              //
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: Text(
                'Timing',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Timing(
                            key: null,
                          )),
                );
                // Handle Settings option tap
              },
              //
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Colors.black,
              ),
              title: Text(
                'Help',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Admin_help_Screen()),
                  );
                }
                // Handle Help option tap
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => loginScreen()),
                      (route) => false,
                    );
                  });
                });
                // Handle logout feature
              },
            ),
            Divider(color: Colors.grey),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('salary')
            .where('empId', isEqualTo: user!.uid)
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
                'No salary detail yet.',
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
                var month = data?['month'];
                var salary = data?["salary"];
                var paid = data?["paid"];
                var year = data?["year"];
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
                    children: [
                      Text(
                        'ID:${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Month: $month $year',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Total: ${salary}'),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Payment status: $paid'),
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
