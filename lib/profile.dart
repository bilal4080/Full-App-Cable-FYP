// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, avoid_print, deprecated_member_use, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  final ref = FirebaseFirestore.instance.collection("users");
  User? user;
  String? userId;
  String? id;
  String? uname;
  String? email;
  String? phoneNumber;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    print("user id: $userId");
    print("user email: ${user?.email}");

    // Retrieve the profile image URL from Firestore and set it to `url`
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      var data = snapshot.data();
      if (data != null) {
        setState(() {
          uname = data['username'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xff392850),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        print("${snapshot.error}");
                        return SizedBox();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: const CircularProgressIndicator());
                      }

                      var data = snapshot.data?.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return SizedBox();
                      }

                      id = data['userId'] as String?;
                      uname = data['username'] as String?;
                      email = data['email'] as String?;
                      phoneNumber = data['uPhone'] as String?;

                      print("id: $id");
                      print("username: $uname");
                      print("email: $email");
                      print("phone number: $phoneNumber");

                      return Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(Icons.person),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Name",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "$uname",
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title:
                                                        Text("Edit Your Name"),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          TextField(
                                                            controller: name,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Your Username",
                                                              fillColor: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              filled: true,
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .person),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              var nameuser = name
                                                                  .text; // Get the updated username
                                                              // Update the username in Firestore
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(userId)
                                                                  .update({
                                                                "username":
                                                                    nameuser,
                                                              });

                                                              // Close the AlertDialog
                                                              Navigator.of(ctx)
                                                                  .pop();

                                                              // Update the UI with the new username
                                                              setState(() {
                                                                uname =
                                                                    nameuser; // Assuming you have `String username = "";` somewhere
                                                              });
                                                            },
                                                            child: Text("Save"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //email
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 20),
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(Icons.email),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Email",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "$email",
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //phone no
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 20),
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(Icons.phone),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Phone",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "$phoneNumber",
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(
                                                        "Edit Your Phone Number"),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          TextField(
                                                            controller:
                                                                phone, // Corrected to use the 'phone' controller
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Your Phone Number",
                                                              fillColor: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.1),
                                                              filled: true,
                                                              prefixIcon:
                                                                  const Icon(Icons
                                                                      .phone_android),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              var phoneno = phone
                                                                  .text; // Get the updated phone number
                                                              // Update the phone number in Firestore
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(userId)
                                                                  .update({
                                                                "uPhone":
                                                                    phoneno,
                                                              });

                                                              // Close the AlertDialog
                                                              Navigator.of(ctx)
                                                                  .pop();

                                                              // Update the UI with the new phone number
                                                              setState(() {
                                                                phoneNumber =
                                                                    phoneno; // Assuming you have `String phoneNumber = "";` somewhere
                                                              });
                                                            },
                                                            child: Text("Save"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
