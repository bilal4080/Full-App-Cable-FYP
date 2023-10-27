// ignore_for_file: unnecessary_new, file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors, avoid_print, unused_element, no_leading_underscores_for_local_identifiers

import 'package:app/User/Complaint/complaintus.dart';
import 'package:app/User/SelfService/Selfservice.dart';
import 'package:app/User/Services/paymnet_controller.dart';
import 'package:app/User/Setting/Setting.dart';
import 'package:app/User/Talkus/Talkus.dart';
import 'package:app/User/TrackOrder/TrackC.dart';
import 'package:app/User/poll/latestpoll.dart';
import 'package:app/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../profile.dart';
import '../Services/Services.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Items item1 = new Items(title: "Self Service", img: "images/selfservice.png");
  Items item2 = new Items(
    title: "Complaint",
    img: "images/complaign.png",
  );
  Items item3 = new Items(
    title: "Track Complaint",
    img: "images/track.png",
  );
  Items item4 = new Items(
    title: "Community",
    img: "images/talkus.png",
  );
  Items item5 = new Items(
    title: "Change Service",
    img: "images/services.png",
  );
  Items item6 = new Items(
    title: "Bills",
    img: "images/setting.jpg",
  );
  Items item7 = new Items(
    title: "Poll",
    img: "images/poll.png",
  );
  User? user;
  String? username;
  String? email;
  String? service;
  double? bill;
  int? paid;

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
          paid = data["paid"];

          userpayment().bill = bill;
          userpayment().service = service;
          userpayment().uid = user!.uid;
        });
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });

    // Fetch employee data from Firestore's "salary" collection
    // _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7
    ]; // Add all items here
    var color = 0xff453658;
    return Scaffold(
      backgroundColor: const Color(0xff392850),
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[200],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
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
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // Do something for Home
                  Navigator.pop(context); // Close the drawer
                },
              ),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  }),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  // Do something for Help
                  Navigator.pop(context); // Close the drawer
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
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
              const Divider(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: GridView.count(
                childAspectRatio: 1.0,
                padding: const EdgeInsets.only(left: 16, right: 16),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: myList.map((data) {
                  return GestureDetector(
                    onTap: () {
                      // Handle item click here
                      _navigateToScreen(
                          data.title); // Call the navigation function
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(color),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            data.img,
                            width: 42,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            data.title,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 8,
                          // ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            // child: PollWidget(),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(String title) {
    if (title == "Self Service") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Self_service()),
      );
    } else if (title == "Complaint") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Cmp()),
      );
    } else if (title == "Track Complaint") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Trackk()),
      );
    } else if (title == "Community") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } else if (title == "Change Service") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Change_services()),
      );
    } else if (title == "Bills") {
      if (paid == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Settings_user()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "No bill yet now for you ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff392850),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else if (title == "Poll") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LatestPollScreen()),
      );
    }
  }
}

class Items {
  String title;
  String img;
  Items({required this.title, required this.img});
}
