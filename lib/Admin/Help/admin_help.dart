// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Admin_help_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff453658),
        title: Text(
          'Admin Help',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          GuideItem(
            title: '1.Login',
            description:
                'Open the Cable Complaint App on your device.\nEnter your admin credentials (username and password) to log in to the admin pane',
          ),
          GuideItem(
            title: '2.Dashboard Overview',
            description:
                'The dashboard provides an overview of recent user complaints, resolved complaints, and pending complaints',
          ),
          GuideItem(
            title: '3.Managing User Queries',
            description:
                'Each complaint entry will display the users name, contact details, complaint description, and current status (pending/resolved)\n Make the App Helpfull for user',
          ),
          GuideItem(
            title: '4.Reviewing Complaints',
            description:
                'Click on a specific complaint to view its details\nReview the complaint description and any attached media (photos, videos, etc.)\nEvaluate the severity of the issue and determine the necessary course of action',
          ),
          GuideItem(
            title: '5.Updating Complaint Status',
            description:
                'If the issue has been resolved, click on the "Resolve" button within the complaint details.\n If the issue requires further investigation or action, click on the "Assign" button to assign the complaint to a specific team member',
          ),
          GuideItem(
            title: '6.System Settings and Maintenance',
            description:
                'Remember, your primary goal is to provide excellent customer service and efficiently address user complaints. Regularly communicate with your support team to ensure a consistent approach to handling user queries and maintaining a high level of user satisfaction.\n By following these guidelines, your admin team can effectively manage user queries and ensure a positive experience within your cable complaint app.',
          ),
        ],
      ),
    );
  }
}

class GuideItem extends StatelessWidget {
  final String title;
  final String description;

  const GuideItem({
    required this.title,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold, // Set the font weight to bold
        ),
      ),
      subtitle: Text(description),
      onTap: () {},
    );
  }
}
