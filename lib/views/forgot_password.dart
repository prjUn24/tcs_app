import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/views/width_and_height.dart';
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
          .sendPasswordResetEmail(email: forgotPasswordController.text.trim());
      showMsg();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'channel-error') {
        showError('Enter the email address');
      } else {
        showError('An error occurred. Please try again.');
      }
    }
  }

  void showError(String msg) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface, // Dialog background
        title: Column(
          children: [
            Lottie.asset('lib/images/error.json', repeat: false),
            Text(
              msg,
              style: TextStyle(color: colorScheme.onSurface), // Dialog text
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: colorScheme.primary), // Button color
            ),
          ),
        ],
      ),
    );
  }

  void showMsg() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface, // Dialog background
        alignment: Alignment.center,
        title: Column(
          children: [
            Lottie.asset('lib/images/verify.json', repeat: false),
            Text(
              'Verification Email Sent',
              style: TextStyle(color: colorScheme.onSurface), // Dialog text
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to the previous screen
            },
            child: Text(
              'Close',
              style: TextStyle(color: colorScheme.primary), // Button color
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    FrameSize.init(context: context);

    return Scaffold(
      backgroundColor: colorScheme.surface, // Background color
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('lib/images/forgot.json', repeat: false),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 32,
                          color: colorScheme.onSurface, // Text color
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Enter your email address below for verification.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface
                                .withOpacity(0.7), // Subdued text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextArea(
                    hintText: 'Email Address',
                    controller: forgotPasswordController,
                    obsureText: false,
                    hintColor: colorScheme.onSurface
                        .withOpacity(0.5), // Hint text color
                    borderColor: colorScheme.primary, // Border color
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: FrameSize.screenWidth * 0.8,
                  child: ButtonTCS(
                    onTap: forgotPassword,
                    txt: 'Send Mail',
                    txtcolor: colorScheme.onPrimary, // Button text color
                    color: colorScheme.primary, // Button background
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: FrameSize.screenWidth * 0.8,
                  child: ButtonTCS(
                    onTap: () => Navigator.pop(context),
                    txt: 'Go back',
                    txtcolor: colorScheme.onPrimary, // Button text color
                    color: colorScheme.secondary, // Secondary color for button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
