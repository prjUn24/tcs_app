// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/services/auth_service.dart';
// import 'package:tcs/views/home_page.dart';
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
  final addressController = TextEditingController();

  @override
  void dispose() {
    emailRegisterController.dispose();
    passwordRegisterController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> addDataToFirestore(User user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the users collection, using the UID as the document ID
    DocumentReference userDoc = firestore.collection('users').doc(user.uid);

    // Set the user data inside the document with UID
    await userDoc.set({
      'address': addressController.text, // User address from the input field
      'authProvider': 'email', // Since we are registering with email
      'createdAt': FieldValue
          .serverTimestamp(), // Timestamp for when the account is created
      'email': emailRegisterController.text, // User email
      'emailVerified': user.emailVerified, // Email verification status
      'name': nameController.text, // User name
      'lastLogin': FieldValue
          .serverTimestamp(), // Timestamp for the last login (initially set to createdAt)
      'number': phoneController.text, // User phone number
    });

    print("User data added to Firestore under UID ${user.uid}");
  }

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return Lottie.asset('lib/images/loading_anim.json');
      },
    );
    try {
      // Validate passwords and required fields
      if (passwordRegisterController.text == confirmPasswordController.text &&
          nameController.text.isNotEmpty) {
        print("Creating user...");

        // Register the user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailRegisterController.text.trim(),
          password: passwordRegisterController.text.trim(),
        );
        Navigator.of(context).pop();
        // Update the display name
        await userCredential.user!
            .updateDisplayName(nameController.text.trim());

        // Add user data to Firestore
        await addDataToFirestore(userCredential.user!);

        // Dismiss the loading dialog

        print("User registration complete.");
      } else {
        // Throw error if passwords mismatch or fields are empty
        throw FirebaseAuthException(
          message: 'Passwords do not match or fields are empty.',
          code: 'passwords_mismatch',
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      showErrorDialog(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      print("Unexpected Error: $e");
      // showErrorDialog('Unexpected error occurred. Please try again.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
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
                  height: FrameSize.screenHeight * 0.03,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FrameSize.screenWidth * 0.08),
                    child: TextArea(
                      obsureText: false,
                      hintText: 'Phone Number',
                      controller: phoneController,
                    )),
                SizedBox(
                  height: FrameSize.screenHeight * 0.03,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: FrameSize.screenWidth * 0.08),
                    child: TextArea(
                      obsureText: false,
                      hintText: 'Address',
                      controller: addressController,
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
