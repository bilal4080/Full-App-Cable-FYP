// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously, avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:async';
import 'package:app/Admin/adminDashboard.dart';
import 'package:app/Emplyee/Dashboard.dart';
import 'package:app/User/Dashboard/Dashboard.dart';
import 'package:app/loder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      final email = user.email;

      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final docSnapshot = querySnapshot.docs.first;
          final data = docSnapshot.data();
          final checkuser = data['checkuser'];

          if (checkuser == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Admin_Dashboard(),
              ),
            );
          } else if (checkuser == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDashboard(),
              ),
            );
          } else if (checkuser == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          }
        }
      } catch (e) {
        print("Error checking user data: $e");
        // Handle the error as needed
      }
    } else {
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/img1.png',
                width: 300,
              ),
              SizedBox(height: 15),
              // Text(
              //   'Cable Ghar',
              //   style: TextStyle(
              //     fontSize: 30,
              //     fontWeight: FontWeight.w300,
              //     color: Colors.white,
              //   ),
              // ),
              Image.asset(
                'images/Logo cable.png',
                height: 140,
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
