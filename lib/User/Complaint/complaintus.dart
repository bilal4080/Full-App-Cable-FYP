// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, sort_child_properties_last, deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cmp extends StatelessWidget {
  const Cmp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complaint",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff392850),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: ComplaintForm(),
      ),
    );
  }
}

class ComplaintForm extends StatefulWidget {
  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  late TextEditingController _complaintController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  bool _isSubmitButtonActive = false;
  bool _isSending = false;
  bool _showSuccessMessage = false;
  User? user;
  String? email;
  String? userId;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    print(userId);
    super.initState();
    _complaintController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    bool isComplaintFilled = _complaintController.text.isNotEmpty;
    bool isAddressFilled = _addressController.text.isNotEmpty;
    bool isPhoneValid =
        _phoneController.text.isNotEmpty && isNumeric(_phoneController.text);

    setState(() {
      _isSubmitButtonActive =
          isComplaintFilled && isAddressFilled && isPhoneValid;
    });
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  Future<void> _submitComplaint() async {
    setState(() {
      _isSending = true;
      _showSuccessMessage = false;
    });

    String complaintText = _complaintController.text;
    String addressText = _addressController.text;
    String phoneNumber = _phoneController.text;

    FirebaseFirestore.instance.collection('complains').doc(user?.uid).set({
      "complain": complaintText,
      "address": addressText,
      "phoneno": phoneNumber,
      "imageurl": null,
      "trackId": user?.email,
      "status": 0,
    });

    await Future.delayed(
        Duration(seconds: 2)); // Simulate sending for 2 seconds

    setState(() {
      _isSending = false;
      _showSuccessMessage = true;
    });
    // Print the complaint text, address, and phone number for now.
    print("Complaint: $complaintText");
    print("Address: $addressText");
    print("Phone Number: $phoneNumber");

    // Clear the text fields after submission.
    _complaintController.clear();
    _addressController.clear();
    _phoneController.clear();

    // Navigate back to the main screen after a brief delay
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop(); // Go back to the previous screen
  }

  ImagePicker picker = ImagePicker();
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        children: [
          Container(
            height: 140,
            child: TextField(
              controller: _complaintController,
              maxLines: 4,
              onChanged: (_) => _validateInputs(),
              decoration: InputDecoration(
                labelText: "Enter your complaint",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            child: TextField(
              controller: _addressController,
              maxLines: 3,
              onChanged: (_) => _validateInputs(),
              decoration: InputDecoration(
                labelText: "Enter your Address",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (_) => _validateInputs(),
              decoration: InputDecoration(
                labelText: "Enter your Phone number",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Attach a Image/Optional"),
          Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () async {
                    image = await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      // Update UI
                    });
                  },
                ),
                if (image != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10), // Set the border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Set the shadow color
                          spreadRadius: 2, // Set the spread radius
                          blurRadius: 5, // Set the blur radius
                          offset: Offset(0, 3), // Set the shadow offset
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // Set the border radius
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover, // Adjust the image fit as needed
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          _isSending
              ? Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text("Sending..."),
                  ],
                )
              : _showSuccessMessage
                  ? Column(
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 48),
                        SizedBox(height: 8),
                        Text("Complaint Sent Successfully!"),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () => {
                        _isSubmitButtonActive ? _submitComplaint : null,
                        _submitComplaint(),
                      },
                      child: Text(
                        "Submit Complaint",
                        style: TextStyle(
                          color: _isSubmitButtonActive
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: _isSubmitButtonActive
                            ? Color(0xff392850)
                            : Colors.grey,
                      ),
                    ),
        ],
      ),
    );
  }
}
