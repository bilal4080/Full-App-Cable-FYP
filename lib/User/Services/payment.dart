// ignore_for_file: camel_case_types, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, prefer_const_constructors, use_key_in_widget_constructors, avoid_unnecessary_containers, curly_braces_in_flow_control_structures

import 'package:app/User/Dashboard/Dashboard.dart';
import 'package:app/User/Services/paymnet_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class payment_method extends StatefulWidget {
  const payment_method({Key? key}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<payment_method> {
  bool _isLoading = false;
  int? input;
  TextEditingController paymentController = TextEditingController();

  Future<void> _sendPayment() async {
    if (userpayment().check == 2 && userpayment().bill == input) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userpayment().uid)
          .update({"paid": 1});
      setState(() {});
    } else if (userpayment().price == input) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(userpayment().uid)
          .update({"service": userpayment().service});
      setState(() {});
    }
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    const url = 'https://www.hblibank.com.pk/Login';
    if (await canLaunch(url)) {
      await launch(url);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DialPad(),
            SizedBox(height: 16),
            TextField(
              controller: paymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter amount',
              ),
            ),
            SizedBox(height: 16),
            BankAccountDisplay(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String inputText =
                    paymentController.text; // Get the input as a string
                input = int.tryParse(inputText); // Try to parse it to an int

                if (input != null) {
                  if (userpayment().price == input ||
                      (userpayment().check == 2 &&
                          userpayment().bill == input)) {
                    if (!_isLoading) {
                      _sendPayment();
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "Enter Correct price",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color(0xff392850),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Invalid input. Please enter a valid number.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xff392850),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: _isLoading ? CircularProgressIndicator() : Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

class DialPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Implement your dial pad UI here
      child: Text('Dial Pad'),
    );
  }
}

class AmountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: ,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter amount',
      ),
    );
  }
}

class BankAccountDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Implement your bank account display UI here
      child: Text('Bank Account:11362778929012'),
    );
  }
}
