// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:app/Emplyee/Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HolidayRequestScreen(),
    );
  }
}

class HolidayRequestScreen extends StatefulWidget {
  @override
  _HolidayRequestScreenState createState() => _HolidayRequestScreenState();
}

class _HolidayRequestScreenState extends State<HolidayRequestScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;

  DateTime selectedDate = DateTime.now();
  String reason = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _sendRequest() async {
    if (_formKey.currentState!.validate()) {
      final holidayRequest = {
        'date': DateFormat('yyyy-MM-dd').format(selectedDate),
        'reason': reason,
        'user_uid': _user!.uid,
        'approved': 0, // Initialize as not approved
      };

      await _firestore.collection('holiday_requests').add(holidayRequest);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Holiday request sent!'),
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmployeeDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holiday Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(selectedDate),
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Reason'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a reason';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    reason = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _sendRequest,
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
