// ignore_for_file: unused_field, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, camel_case_types, prefer_const_constructors, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PollService {
  final CollectionReference _pollsCollection =
      FirebaseFirestore.instance.collection('polls');

  Future<void> createPoll(String question, List<String> options) async {
    try {
      final pollData = {
        'question': question,
        'options': options,
        'votes': {},
        "date": DateTime.now()
      };

      await _pollsCollection.add(pollData);
    } catch (e) {
      print('Error creating poll: $e');
      throw Exception('Failed to create poll');
    }
  }
}

class Polls_admin extends StatefulWidget {
  @override
  _Polls_adminState createState() => _Polls_adminState();
}

class _Polls_adminState extends State<Polls_admin> {
  final _pollsCollection = FirebaseFirestore.instance.collection('polls');
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    _optionControllers.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create poll',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff392850),
      ),
      body: Column(
        children: [
          _buildPollForm(),
        ],
      ),
    );
  }

  Widget _buildPollForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Poll Question'),
            ),
            Column(
              children: _optionControllers.map((controller) {
                return TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Option'),
                  onSubmitted: (_) => _addOption(),
                );
              }).toList(),
            ),
            if (_optionControllers.length <
                3) // Display the "Add Option" button only if there are less than 3 options
              ElevatedButton(
                onPressed: _addOption,
                child: Text('Add Option'),
              ),
            ElevatedButton(
              onPressed: _createPoll,
              child: Text('Create Poll'),
            ),
          ],
        ),
      ),
    );
  }

  void _addOption() {
    if (_optionControllers.length < 3) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    }
  }

  Future<void> _createPoll() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      return;
    }

    final pollOptions = _optionControllers
        .map((controller) => controller.text.trim())
        .where((option) => option.isNotEmpty)
        .toList();

    if (pollOptions.isEmpty) {
      return;
    }

    final pollService = PollService();
    await pollService.createPoll(question, pollOptions);

    setState(() {
      _questionController.clear();
      _optionControllers.forEach((controller) => controller.clear());
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: Polls_admin(),
  ));
}
