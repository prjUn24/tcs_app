import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgotPasswordController.text);
      showMsg();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'channel-error') {
        return showError('Enter the email address');
      }
    }
  }

  void showError(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Lottie.asset('lib/images/error.json',
                repeat: false, frameRate: const FrameRate(100)),
            Text(msg),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showMsg() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Column(
          children: [
            Lottie.asset('lib/images/verify.json', repeat: false),
            const Text('Verification Email sent')
          ],
        ),
        contentTextStyle: const TextStyle(),
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
              Lottie.asset('lib/images/forgot.json', repeat: false),
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
