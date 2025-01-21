import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/services/auth_service.dart';
import 'package:tcs/views/forgot_password.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/text_area.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Lottie.asset('lib/images/loading_anim.json');
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code.isNotEmpty) {
        print('something WRONG!!!!!!!! ' + e.code);
        Navigator.of(context).pop();
        _showErrorDialog('Invalid Credentials',
            'The Email or password you have entered is incorrect.');
      }
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    showDialog(
      context: context,
      builder: (context) {
        return Lottie.asset('lib/images/loading_anim.json');
      },
    );
    try {
      UserCredential userCredential = await AuthService().signinWithGoogle();
      Navigator.of(context).pop();
      // Add user data to Firestore
      await addGoogleUserToFirestore(userCredential.user);
    } catch (e) {
      // Navigator.of(context).pop();
      _showErrorDialog('Google Sign-In Failed', 'Please try again.');
    }
  }

  // Add Google user to Firestore
  Future<void> addGoogleUserToFirestore(User? user) async {
    if (user != null) {
      final userDoc = firestore.collection('users').doc(user.uid);

      // Check if the user already exists in Firestore
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email ?? "",
          'name': user.displayName ?? "",
          'number': user.phoneNumber ?? "",
          'address': "",
          'authProvider': "Google",
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'emailVerified': user.emailVerified,
        });
      } else {
        // Update the `lastLogin` field if the user exists
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // Display error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.surface, // Surface for background
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: FrameSize.screenHeight * 0.1),
                Image.asset(
                  'lib/images/tcs.png',
                  scale: 1.5,
                ),
                SizedBox(height: FrameSize.screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextArea(
                    obsureText: false,
                    hintText: 'Email',
                    controller: emailController,
                  ),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextArea(
                    obsureText: true,
                    hintText: 'Password',
                    controller: passwordController,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: colorScheme.onSurface
                                  .withOpacity(0.6)), // Subdued text
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.02),
                SizedBox(
                  width: FrameSize.screenWidth * 0.8,
                  child: ButtonTCS(
                    txt: 'L O G I N',
                    onTap: signUserIn,
                    txtcolor: colorScheme.onPrimary, // Text color on buttons
                    color: colorScheme.primary
                        .withOpacity(0.8), // Primary for button background
                  ),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'or continue with',
                        style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: signInWithGoogle,
                  child: Image.asset(
                    'lib/images/google.png',
                    scale: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member',
                      style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                            color: colorScheme
                                .secondary), // Secondary color for links
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
