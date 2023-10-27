// admin_chat_screen.dart

// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  TextEditingController messageController = TextEditingController();
  String? selectedUser;
  List<String> chatMessages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Chat'),
      ),
      body: Column(
        children: [
          if (selectedUser != null)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(chatMessages[index]),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _sendMessage(messageController.text);
                        },
                        child: Text('Send'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showUserListDialog();
                },
                child: Text('Select a user to chat with'),
              ),
            ),
        ],
      ),
    );
  }

  void _showUserListDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a user to chat with'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fetch and display a list of users here
              // Use the User model to represent user data
              ListTile(
                title: Text('User 1'),
                onTap: () {
                  setState(() {
                    selectedUser =
                        'User 1'; // Replace with the selected user's ID
                    chatMessages
                        .clear(); // Clear chat messages when a new user is selected
                  });
                  _loadChatMessages(); // Load chat messages for the selected user
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('User 2'),
                onTap: () {
                  setState(() {
                    selectedUser =
                        'User 2'; // Replace with the selected user's ID
                    chatMessages
                        .clear(); // Clear chat messages when a new user is selected
                  });
                  _loadChatMessages(); // Load chat messages for the selected user
                  Navigator.of(context).pop();
                },
              ),
              // Add more users as needed
            ],
          ),
        );
      },
    );
  }

  Future<void> _loadChatMessages() async {
    final messagesRef = FirebaseFirestore.instance.collection('messages');
    final chatSnapshot = await messagesRef
        .where('receiver', isEqualTo: selectedUser)
        .orderBy('timestamp')
        .get();

    setState(() {
      chatMessages = chatSnapshot.docs
          .map((messageDoc) => messageDoc['text'].toString())
          .toList();
    });
  }

  void _sendMessage(String text) {
    if (text.isNotEmpty && selectedUser != null) {
      FirebaseFirestore.instance.collection('messages').add({
        'sender': 'admin',
        'receiver': selectedUser,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageController.clear();
      _loadChatMessages(); // Load updated chat messages after sending a new message
    }
  }
}
