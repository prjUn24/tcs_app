import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/services/auth_service.dart';
// import 'package:tcs/views/login_page.dart';
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
      if (passwordRegisterController.text == confirmPasswordController.text) {
        // Attempt to create the user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailRegisterController.text,
          password: passwordRegisterController.text,
        );

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'lib/images/tcs.png',
                  scale: 1.5,
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Let's create an account for you",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextArea(
                      obsureText: false,
                      hintText: 'Email',
                      controller: emailRegisterController,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextArea(
                      obsureText: true,
                      hintText: 'Password',
                      controller: passwordRegisterController,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextArea(
                      obsureText: true,
                      hintText: 'Confirm Password',
                      controller: confirmPasswordController,
                    )),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ButtonTCS(
                    txt: 'REGISTER',
                    onTap: registerUser,
                    color: Colors.green[200],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.blueGrey,
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'or continue with',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.blueGrey,
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 10,
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
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
