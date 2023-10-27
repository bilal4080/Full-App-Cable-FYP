// ignore_for_file: unnecessary_import, library_private_types_in_public_api, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff392850),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        // Add your desired widget here
                      ),
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      'Cable Ghar',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => loginScreen()),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegScreen()),
                        );
                      },
                      child: Container(
                        height: 53,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Text(
                      'We are Fastest and Secure', // Added text
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
