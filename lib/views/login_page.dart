import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/services/navigation_service.dart';
import 'package:tcs/services/auth_service.dart';
import 'package:tcs/views/forgot_password.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/text_area.dart';
import 'package:toastification/toastification.dart';

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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUserIn() async {
    NavigationService.navigatorKey.currentState?.push(
      DialogRoute(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) => Lottie.asset('lib/images/loading_anim.json'),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      NavigationService.navigatorKey.currentState?.pop();
    } on FirebaseAuthException catch (e) {
      NavigationService.navigatorKey.currentState?.pop();
      _showErrorDialog(
        'Invalid Credentials',
        'The Email or password you have entered is incorrect.',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    NavigationService.navigatorKey.currentState?.push(
      DialogRoute(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) => Lottie.asset('lib/images/loading_anim.json'),
      ),
    );

    try {
      UserCredential userCredential = await AuthService().signinWithGoogle();
      NavigationService.navigatorKey.currentState?.pop();
      await addGoogleUserToFirestore(userCredential.user);
    } catch (e) {
      NavigationService.navigatorKey.currentState?.pop();
      showToast(
        context,
        'Error',
        'Google Sign-In Failed',
        ToastificationType.error,
      );
      debugPrint("Error during Google sign-in: $e");
    }
  }

  Future<void> addGoogleUserToFirestore(User? user) async {
    if (user != null) {
      final userDoc = firestore.collection('users').doc(user.uid);

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
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  void showToast(BuildContext context, String title, String description,
      ToastificationType type) {
    toastification.show(
      context: context,
      type: type,
      title: Text(title),
      description: Text(description),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 3),
      progressBarTheme: ProgressIndicatorThemeData(
        color: type == ToastificationType.success
            ? Colors.green
            : type == ToastificationType.info
                ? Colors.blue
                : type == ToastificationType.warning
                    ? Colors.orange
                    : Colors.red,
      ),
      showProgressBar: true,
      backgroundColor: type == ToastificationType.success
          ? Colors.green
          : type == ToastificationType.info
              ? Colors.blue
              : type == ToastificationType.warning
                  ? Colors.orange
                  : Colors.red,
      foregroundColor: Colors.white,
    );
  }

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
      backgroundColor: const Color(0xFFF8E8F5), // Updated background color
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'lib/images/bg.png', // Add your image
                fit: BoxFit.cover,
              ),
            ),
            // Existing content
            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: FrameSize.screenHeight * 0.1),
                      Image.asset(
                        'lib/images/tcs.png',
                        scale: 2,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6)),
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
                          txtcolor: Colors.white,
                          color: const Color.fromARGB(255, 86, 122, 155),
                          // rgb(86, 122, 155)
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
                                  color:
                                      colorScheme.onSurface.withOpacity(0.7)),
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
                          scale: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Not a member',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
