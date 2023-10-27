// lib/widgets/message_widget.dart

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isCurrentUser;

  MessageWidget({required this.text, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Color(0xff453658) : Colors.grey,
          borderRadius: isCurrentUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
