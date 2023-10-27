// ignore_for_file: prefer_const_constructors, file_names, camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Self_service extends StatelessWidget {
  const Self_service({super.key});
  Future<void> _launchURL() async {
    const url = 'https://www.wikihow.com/Fix-Cable-TV';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Self Service",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff392850),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cable Issue Troubleshooting",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Problem: No Internet Connection",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Solution:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "1. Check if the cables are properly connected to your modem and router.",
              ),
              Text(
                "2. Restart your modem and router by unplugging them from the power source, waiting for 30 seconds, and plugging them back in.",
              ),
              Text(
                "3. Ensure that all the lights on your modem and router are lit up and stable.",
              ),
              Text(
                "4. If the issue persists, contact your internet service provider for further assistance.",
              ),
              SizedBox(height: 16),
              Text(
                "Problem: Weak Wi-Fi Signal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Solution:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "1. Reposition your router to a central location in your home or closer to the areas with weak signal.",
              ),
              Text(
                "2. Remove any obstacles or interference between your device and the router, such as walls or large objects.",
              ),
              Text(
                "3. Consider using a Wi-Fi range extender or mesh network system to improve coverage.",
              ),
              Text(
                "4. If the issue persists, contact your internet service provider for further assistance.",
              ),
              SizedBox(height: 8),
              Text(
                "1. Rule out other devices that are connected to your television. Disconnect all devices and test each one individually to identify the source of the incompatible picture.",
              ),
              Text(
                "2. Check your television's compatibility with the specific signal from the pass-through device. Refer to your television's manual or manufacturer's website for information on supported signals.",
              ),
              SizedBox(height: 16),
              Text(
                "Problem: Incorrect Video Input",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Solution:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "1. Check the physical connection of the video input on your television. Ensure that the cable is securely plugged into the correct port.",
              ),
              Text(
                "2. Verify the correct video input setting on your television. Access the television's 'Input' or 'Source' settings and select the appropriate input channel (e.g., channel 03, channel 04, CATV, AV1, AV2, Video 1, HDMI, etc.).",
              ),
              SizedBox(height: 16),
              Text(
                "Note: Language-specific instructions for changing video input settings may vary. Please refer to your television's manual or manufacturer's website for detailed instructions in your preferred language.",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _launchURL();
                },
                child: Text(
                  "For more information, click here",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
