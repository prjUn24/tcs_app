import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/services/auth_service.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/text_area.dart';

class RegistrationPage extends StatefulWidget {
  final Function()? onTap;
  const RegistrationPage({super.key, this.onTap});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailRegisterController = TextEditingController();
  final passwordRegisterController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void registerUser() async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Check if passwords match
      if (passwordRegisterController.text == confirmPasswordController.text &&
          nameController.text.isNotEmpty) {
        // Attempt to create the user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailRegisterController.text,
          password: passwordRegisterController.text,
        );

        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(nameController.text);

        // Successfully created user; pop the loading dialog
        Navigator.pop(context);
        // Optional: Show success message or navigate to another screen
      } else {
        // Passwords don't match; show error dialog
        Navigator.pop(context); // Pop the loading dialog
        wrongCredentials();
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Pop the loading dialog

      // Handle specific Firebase errors
      wrongCredentials();
      print("Firebase Auth Error: ${e.message}");
    } catch (e) {
      Navigator.pop(context); // Pop the loading dialog

      // Handle any other unexpected errors
      print("Unexpected Error: $e");
    }
  }

  void wrongCredentials() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Credentials'),
        content:
            const Text('The Email or password you have entered is invalid.'),
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

  @override
  Widget build(BuildContext context) {
    FrameSize.init(context: context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.only(top: FrameSize.screenHeight * 0.05),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/tcs.png',
                  scale: 1.5,
                ),
                SizedBox(
                  height: FrameSize.screenHeight * 0.05,
                ),
                const Text(
                  "Let's create an account for you",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: FrameSize.screenHeight * 0.02,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FrameSize.screenWidth * 0.08),
                    child: TextArea(
                      obsureText: false,
                      hintText: 'Email',
                      controller: emailRegisterController,
                    )),
                SizedBox(
                  height: FrameSize.screenHeight * 0.03,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FrameSize.screenWidth * 0.08),
                    child: TextArea(
                      obsureText: false,
                      hintText: 'Name',
                      controller: nameController,
                    )),
                SizedBox(
                  height: FrameSize.screenHeight * 0.03,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FrameSize.screenWidth * 0.08),
                    child: TextArea(
                      obsureText: true,
                      hintText: 'Password',
                      controller: passwordRegisterController,
                    )),
                SizedBox(
                  height: FrameSize.screenHeight * 0.03,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FrameSize.screenWidth * 0.08),
                    child: TextArea(
                      obsureText: true,
                      hintText: 'Confirm Password',
                      controller: confirmPasswordController,
                    )),
                SizedBox(
                  height: FrameSize.screenHeight * 0.05,
                ),
                Container(
                  height: FrameSize.screenHeight * 0.07,
                  margin: EdgeInsets.symmetric(
                      horizontal: FrameSize.screenWidth * 0.08),
                  child: ButtonTCS(
                    txtcolor: Colors.black,
                    txt: 'REGISTER',
                    onTap: registerUser,
                    color: Colors.green[200],
                  ),
                ),
                SizedBox(
                  height: FrameSize.screenHeight * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: FrameSize.screenWidth * 0.08),
                  child: Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.blueGrey,
                      )),
                      SizedBox(
                        width: FrameSize.screenWidth * 0.02,
                      ),
                      const Text(
                        'or continue with',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: FrameSize.screenWidth * 0.02,
                      ),
                      const Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.blueGrey,
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: FrameSize.screenHeight * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    AuthService().signinWithGoogle();
                  },
                  child: Image.asset(
                    'lib/images/google.png',
                    scale: 15,
                  ),
                ),
                SizedBox(
                  height: FrameSize.screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: FrameSize.screenWidth * 0.02,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: FrameSize.screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
