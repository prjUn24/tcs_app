import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/text_area.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final forgotPasswordController = TextEditingController();

  void forgotPassword() async {
    try {
      showMsg();
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgotPasswordController.text);
    } on FirebaseAuthException catch (e) {
      // print(e.message);
    }
  }

  void showMsg() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Email Sent'),
        content: const Text('Open your Inbox and follow the instructions'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Text(
                      'Forgot Password ?',
                      style: TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Text(
                      'Enter your Email address below for verification',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextArea(
                    hintText: 'Email Address',
                    controller: forgotPasswordController,
                    obsureText: false),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                // padding:
                // const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ButtonTCS(
                  onTap: forgotPassword,
                  txt: 'Send Mail',
                  txtcolor: Colors.black,
                  color: Colors.green[200],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                // padding:const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: ButtonTCS(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  txt: 'Go back',
                  txtcolor: Colors.black,
                  color: Colors.green[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
