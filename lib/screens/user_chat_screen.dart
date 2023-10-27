// lib/screens/user_chat_screen.dart

// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/message_widget.dart';

class UserChatScreen extends StatefulWidget {
  final String currentUserId;
  final String adminId;

  UserChatScreen(
      {required this.currentUserId, required this.adminId, required key});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Chat"),
      ),
      body: Column(
        children: <Widget>[
          // StreamBuilder for messages
          // Similar to the example code in previous responses

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      // Send the message to Firestore
      // Add logic to handle message sending

      _messageController.clear();
    }
  }
}
