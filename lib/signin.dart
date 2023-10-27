// ignore_for_file: unused_import, avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, camel_case_types, unused_element, unused_local_variable, unused_field

// import 'package:app/Admin/adminDashboard.dart';
// import 'package:app/user/signup.dart';
// import 'package:app/user/userdashboard.dart';
import 'package:app/Admin/AdminDashboard.dart';
import 'package:app/Emplyee/Dashboard.dart';
// import 'package:app/Employee/Dashboard.dart';
import 'package:app/User/Dashboard/Dashboard.dart';
import 'package:app/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import '../Driver/drivre_dashboard.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _emailErrorText;
  String? _passwordErrorText;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length > 8) {
      return 'Password should have a maximum of 8 characters';
    }
    return null;
  }

  void _clearErrorText() {
    setState(() {
      _emailErrorText = null;
      _passwordErrorText = null;
    });
  }

  // void login() {
  //   setState(() {
  //     _clearErrorText();
  //     emailController.text = emailController.text.trim();
  //     passwordController.text = passwordController.text.trim();
  //   });

  //   final emailError = validateEmail(emailController.text);
  //   final passwordError = validatePassword(passwordController.text);

  //   if (emailError == null && passwordError == null) {
  //     FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text,
  //       password: passwordController.text,
  //     );
  //     // Check if the email and password match the admin credentials
  //     if (emailController.text == 'admin@example.com' &&
  //         passwordController.text == 'A1234567') {
  //       // Redirect to the admin panel
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => FuelAppDashboard(),
  //         ),
  //       );
  //     } else {
  //       // Redirect to the user dashboard
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => UserDashboardScreen(),
  //         ),
  //       );
  //     }
  //   } else {
  //     setState(() {
  //       _emailErrorText = emailError;
  //       _passwordErrorText = passwordError;
  //     });
  //   }
  // }

  User? user;
  String? email;
  bool isPasswordVisible = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    print("user email: ${user?.email}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.email, color: Color(0xff392850)),
          ),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock, color: Color(0xff392850)),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              child: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Color(0xff392850),
              ),
            ),
          ),
          obscureText: !isPasswordVisible,
          controller: passwordController,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var loginEmail = emailController.text.trim();
            var loginPassword = passwordController.text.trim();
            final emailError = validateEmail(emailController.text);
            final passwordError = validatePassword(passwordController.text);

            try {
              setState(() {
                _clearErrorText();
                emailController.text = emailController.text.trim();
                passwordController.text = passwordController.text.trim();
              });
              if (emailError == null && passwordError == null) {
                try {
                  final UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: loginEmail,
                    password: loginPassword,
                  );
                  final User? firebaseUser = userCredential.user;

                  if (firebaseUser != null) {
                    FirebaseFirestore.instance
                        .collection("users")
                        .where("email", isEqualTo: loginEmail)
                        .get()
                        .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        final docSnapshot = querySnapshot.docs.first;
                        Map<String, dynamic> data = docSnapshot.data();
                        int checkuser = data['checkuser'];
                        print('checkuser: $checkuser');

                        if (checkuser == 1) {
                          if (userCredential.user != null) {
                            // Navigate to the AdminDashboard screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Admin_Dashboard()),
                            );
                          } else {
                            // Handle login failure (show an error message, etc.)
                          }
                        } else if (checkuser == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                          );
                        } else if (checkuser == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeDashboard()),
                          );
                        }
                      } else {
                        print('User document does not exist');
                      }
                    });
                  }
                  print('Login Successful');
                } on FirebaseAuthException catch (e) {
                  Fluttertoast.showToast(
                    msg: "$e",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color.fromARGB(255, 7, 80, 140),
                    textColor: Colors.white,
                  );
                }
              } else {
                setState(() {
                  _emailErrorText = emailError;
                  _passwordErrorText = passwordError;
                });
              }
              ();
            } on FirebaseAuthException catch (e) {
              Fluttertoast.showToast(
                msg: "$e",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xff392850),
                textColor: Colors.white,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff392850),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   // MaterialPageRoute(builder: (context) => forgetPassword()),
        // );
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Color(0xff392850)),
      ),
    );
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Color(0xff392850)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
