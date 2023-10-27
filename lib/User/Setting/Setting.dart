// ignore_for_file: file_names, library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, sized_box_for_whitespace, avoid_print, unused_local_variable

import 'package:app/User/Services/payment.dart';
import 'package:app/User/Services/paymnet_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings_user extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Settings_user> {
  get color1 => Color(0xff453658);

  get color2 => Color(0xff392850);

  get color3 => Color(0xff453658);

  get textcolor => Colors.white;
  String? currentMonthName;
  int? currentYear;
  User? user;
  double? total;
  @override
  void initState() {
    super.initState();

    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
        if (user != null) {
          // If the user is authenticated, fetch Firestore data
          fetchData();
        }
      });
    });
  }

  Future<double?> fetchData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> complainDocSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .get();

      if (complainDocSnapshot.exists) {
        Map<String, dynamic> data =
            complainDocSnapshot.data() as Map<String, dynamic>;
        // Assuming 'status' field exists in your Firestore data
        total = data['bill'];
        userpayment().bill = total;
        print("total$total");
      }
    } catch (e) {
      print("Error fetching Firestore data: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    setState(() {
      final now = DateTime.now();
      currentYear = now.year;
      final currentMonth = now.month;
      final monthNames = [
        '', // Index 0 is left empty since months are 1-based
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      currentMonthName = monthNames[currentMonth];
      print('Current Month: $currentMonthName');
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff453658),
        title: Text(
          'Bills',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: color1,
      body: Stack(
        children: [
          Positioned(
              top: 50,
              left: 30,
              child: Text(
                "Your Recent Bills",
                style: TextStyle(
                  color: textcolor,
                  letterSpacing: 2,
                  fontSize: 30,
                ),
              )),
          Positioned(
            top: 90,
            left: 30,
            child: Text(
              "$currentMonthName $currentYear",
              style: TextStyle(
                color: textcolor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Positioned(
            top: 155,
            left: 30,
            child: billedContainer(size),
          ),
        ],
      ),
    );
  }

  Widget nearbyFriends(Size size) {
    return Container(
      height: size.height / 3.7,
      width: size.width / 1.15,
      decoration: BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 100,
            child: Text(
              "",
              style: TextStyle(
                color: textcolor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recentSplits(Size size, String imageUrl, String name) {
    return Container(
      height: size.height / 10,
      width: size.width / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: size.height / 20,
            width: size.height / 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imageUrl),
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
              color: color2,
            ),
          )
        ],
      ),
    );
  }

  Widget previousParticipants(Size size, String imageUrl, String name) {
    return Container(
      height: size.height / 10,
      width: size.width / 7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color1,
      ),
      child: Column(
        children: [
          Container(
            height: size.height / 14.5,
            width: size.width / 14.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
              color: color2,
            ),
          )
        ],
      ),
    );
  }

  Widget billedContainer(Size size) {
    return Container(
      height: size.height / 3,
      width: size.width / 1.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color2,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: Text(
              "Total Bill",
              style: TextStyle(
                color: textcolor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 55,
            left: 30,
            child: Text(
              "${userpayment().bill}",
              style: TextStyle(
                color: textcolor,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            child: GestureDetector(
              onTap: () {
                userpayment().check = 2;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => payment_method(),
                  ),
                );
              },
              child: Material(
                color: color1,
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: size.height / 12,
                  width: size.width / 3.5,
                  alignment: Alignment.center,
                  child: Text(
                    "Pay Now",
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
