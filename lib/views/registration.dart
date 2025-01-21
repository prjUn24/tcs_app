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
      Navigator.of(context).pop();
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
    final colorScheme = Theme.of(context).colorScheme;
    FrameSize.init(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.surface, // Use surface for background
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
                SizedBox(height: FrameSize.screenHeight * 0.05),
                Text(
                  "Let's create an account for you",
                  style: TextStyle(
                      color: colorScheme.onSurface
                          .withOpacity(0.7)), // Subdued text color
                ),
                SizedBox(height: FrameSize.screenHeight * 0.02),
                _buildTextField(
                    emailRegisterController, 'Email', false, colorScheme),
                _buildSpacer(),
                _buildTextField(nameController, 'Name', false, colorScheme),
                _buildSpacer(),
                _buildTextField(
                    passwordRegisterController, 'Password', true, colorScheme),
                _buildSpacer(),
                _buildTextField(confirmPasswordController, 'Confirm Password',
                    true, colorScheme),
                _buildSpacer(),
                _buildTextField(
                    phoneController, 'Phone Number', false, colorScheme),
                _buildSpacer(),
                _buildTextField(
                    addressController, 'Address', false, colorScheme),
                SizedBox(height: FrameSize.screenHeight * 0.05),
                Container(
                  height: FrameSize.screenHeight * 0.07,
                  margin: EdgeInsets.symmetric(
                      horizontal: FrameSize.screenWidth * 0.08),
                  child: SizedBox(
                    width: FrameSize.screenWidth * 0.8,
                    child: ButtonTCS(
                      txtcolor: colorScheme.onPrimary, // Text color on button
                      txt: 'REGISTER',
                      onTap: registerUser,
                      color: colorScheme
                          .primary, // Primary color for button background
                    ),
                  ),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: FrameSize.screenWidth * 0.08),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(thickness: 0.5, color: Colors.blueGrey),
                      ),
                      SizedBox(width: FrameSize.screenWidth * 0.02),
                      Text(
                        'or continue with',
                        style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7)),
                      ),
                      SizedBox(width: FrameSize.screenWidth * 0.02),
                      const Expanded(
                        child: Divider(thickness: 0.5, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.01),
                GestureDetector(
                  onTap: () {
                    AuthService().signinWithGoogle();
                  },
                  child: Image.asset(
                    'lib/images/google.png',
                    scale: 15,
                  ),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: colorScheme.onSurface
                              .withOpacity(0.7)), // Subdued text
                    ),
                    SizedBox(width: FrameSize.screenWidth * 0.02),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: colorScheme.secondary), // Secondary for link
                      ),
                    ),
                  ],
                ),
                SizedBox(height: FrameSize.screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      bool obscureText, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: FrameSize.screenWidth * 0.08),
      child: TextArea(
        obsureText: obscureText,
        hintText: hintText,
        controller: controller,
        hintColor: colorScheme.onSurface.withOpacity(0.5), // Hint text color
        borderColor: colorScheme.primary, // Border color
      ),
    );
  }

  Widget _buildSpacer() {
    return SizedBox(height: FrameSize.screenHeight * 0.03);
  }
}
