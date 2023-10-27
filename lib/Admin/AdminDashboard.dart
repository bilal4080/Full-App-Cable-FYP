// ignore_for_file: file_names, library_private_types_in_public_api, camel_case_types, prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print, unrelated_type_equality_checks, unused_local_variable, unnecessary_brace_in_string_interps

import 'package:app/Admin/Bills/Bills.dart';
import 'package:app/Admin/emplyees.dart';
import 'package:app/Admin/holidaysreques.dart';
import 'package:app/Admin/polls/allpolls.dart';
import 'package:app/User/poll/latestpoll.dart';
import 'package:app/Admin/polls/polls.dart';
import 'package:app/screens/admin_chat_screen.dart';
import 'package:app/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Help/admin_help.dart';

class Admin_Dashboard extends StatefulWidget {
  const Admin_Dashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<Admin_Dashboard> {
  User? user;
  String? userId;
  String? username;
  String? email;
  Timestamp? request_time;

  String? date;
  String formatRequestTime(Timestamp? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = timestamp.toDate();
      date = DateFormat('yyyy-MM-dd ').format(dateTime);
      return DateFormat('HH:mm:ss').format(dateTime);
    } else {
      return '';
    }
  }

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    print("initState called");
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    // Retrieve the profile image URL from Firestore and set it to `url`
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      print("Fetched data: $data");
      if (data != null) {
        print("User data retrieved: $data"); // Check if data is being retrieved
        setState(() {
          email = data['email'];
          username = data['username'];
        });
      } else {
        print(
            "User data not found!"); // Check if data retrieval is unsuccessful
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff453658),
        title: Text(
          'Admin Complaints',
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
                    MaterialPageRoute(builder: (context) => Admin_Dashboard()),
                  );
                }
                // Handle Home option tap
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.black,
                ),
                title: Text(
                  'Bills',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const bills_user()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.person_2,
                  color: Colors.black,
                ),
                title: Text(
                  'Employee',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const employee()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.poll_rounded,
                  color: Colors.black,
                ),
                title: Text(
                  'Polls',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Polls_admin()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.polymer_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  'Polls',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewPollsScreen()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
                leading: Icon(
                  Icons.chat_bubble,
                  color: Colors.black,
                ),
                title: Text(
                  'Chats',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminChatScreen()),
                  );
                }),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(
                Icons.request_page,
                color: Colors.black,
              ),
              title: Text(
                'Holidays Requests',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => holidaysRequests()),
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('complains')
            .where('status', isNotEqualTo: 2)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Center(
              child: Text(
                'No complaints yet.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot document = documents[index];
                Map<String, dynamic>? data =
                    documents[index].data() as Map<String, dynamic>?;
                var address = data?['address'];
                var phoneno = data?["phoneno"];
                var description = data?["complain"];
                var status = data?["status"];
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
                        'Address: $address',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Phone Number: ${phoneno}'),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Description: $description'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_file),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("complains")
                                  .doc(document.id)
                                  .update({"status": 1});
                              setState(() {});
                            },
                            child: Text('In Progress'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("complains")
                                  .doc(document.id)
                                  .update({"status": 2});
                            },
                            child: Text('Resolved'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),
      // body: complaints.isEmpty
      //     ? Center(
      //         child: Text(
      //           'No complaints yet',
      //           style: TextStyle(fontSize: 18),
      //         ),
      //       )
      //     : ListView.builder(
      //         itemCount: complaints.length,
      //         itemBuilder: (context, index) {
      //           return ComplaintCard(
      //             complaint: complaints[index],
      //             onResolved: () {
      //               setState(() {
      //                 complaints.removeAt(index);
      //               });
      //             },
      //             onInProgress: () {
      //               setState(() {
      //                 complaints[index].inProgress = true;
      //               });
      //             },
      //           );
      //         },
      //       ),
    );
  }
}
