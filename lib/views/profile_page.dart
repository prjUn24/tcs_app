import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs/theme/theme.dart';
import 'package:tcs/theme/theme_provider.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/text_area.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var user = FirebaseAuth.instance.currentUser;
  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  final newEmail = TextEditingController();
  final oldEmail = TextEditingController();
  final oldEmailPass = TextEditingController();

  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  final changeName = TextEditingController();

  final FirebaseFirestore fireStoreData = FirebaseFirestore.instance;

  bool isGoogle = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified();
    findIsGoogle();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut() => _googleSignIn.disconnect();
  late bool emailVerified;

  bool toEdit = false;

  void findIsGoogle() async {
    final userDoc =
        await fireStoreData.collection('users').doc(user!.uid).get();
    if (userDoc.exists) {
      setState(() {
        isGoogle = userDoc.data()?['authProvider'] == 'Google';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    addressController.dispose();
    newEmail.dispose();
    oldEmail.dispose();
    oldEmailPass.dispose();
    oldPass.dispose();
    newPass.dispose();
    confirmPass.dispose();
    changeName.dispose();
  }

  // Method to check if email is verified.
  void isEmailVerified() {
    // setState(() {
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    // });
    // print("This is the output of email Verification: $emailVerified");
  }

  void _showAddressDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Enter Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Full Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                updateAddress(user);
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to send a verification email
  Future<void> verifyEmail() async {
    try {
      // Check if a user is currently signed in
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is currently signed in.");
        return;
      }

      // Send the verification email
      await user.sendEmailVerification();

      // Optionally, you can display a confirmation message
      print("Verification email sent to ${user.email}");

      // Trigger the check for email verification status after a delay
      // We add a delay to give time for the email to be processed
      await Future.delayed(
          Duration(seconds: 3)); // Wait 3 seconds for email to be sent
      isEmailVerified(); // Re-check the email verification status

      // Optionally, you can keep checking periodically (not necessary for basic use cases)
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          isEmailVerified();
        }
      });
    } on FirebaseAuthException catch (e) {
      // Handle error when sending email
      print("Error sending verification email: ${e.message}");
    }
  }

  void updateNewName(User? user) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(changeName.text);
      if (user != null) {
        final userDoc = fireStoreData.collection('users').doc(user.uid);

        // Check if the user already exists in Firestore
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists) {
          await userDoc.update({
            'name': changeName.text,
          });
          print('NAME UPDATION');
        }
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update name: ${e.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void updateNewEmail() async {
    try {
      // Reauthenticate the user
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: oldEmail.text,
          password: oldEmailPass.text,
        ),
      );

      // Send a verification email to the new address
      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(newEmail.text);

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verification Email Sent'),
            content: const Text(
              'A verification email has been sent to your new email address. Please verify to complete the update.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signUserOut(); // Sign out after showing the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update email: ${e.message}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void updatePassword() async {
    if (newPass.text != confirmPass.text) {
      // Show an error dialog for mismatched passwords
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('New password and confirm password do not match.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Reauthenticate the user
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: oldEmail.text, // The user's current email
          password: oldPass.text, // The user's current password
        ),
      );

      // Update the password
      await FirebaseAuth.instance.currentUser!.updatePassword(newPass.text);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Password has been updated successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage = 'Failed to update password.';
      if (e.code == 'weak-password') {
        errorMessage = 'The new password is too weak.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'The old password is incorrect.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage =
            'Please log in again to update your password for security reasons.';
      }

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Generic error handling
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An unexpected error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void addPhoneNumber(User? user) async {
    if (user != null) {
      final userDoc = fireStoreData.collection('users').doc(user.uid);

      // Check if the user already exists in Firestore
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        await userDoc.update({
          'number': phoneController.text,
        });
        print('MOBILE NUMBER UPDATION');
      }
    }
  }

  void updateAddress(User? user) async {
    if (user != null) {
      final userDoc = fireStoreData.collection('users').doc(user.uid);

      // Check if the user already exists in Firestore
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        await userDoc.update({
          'address': addressController.text,
        });
        print('ADDRESS UPDATION');
      }
    }
  }

  void deleteUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .delete();
      await FirebaseAuth.instance.currentUser!.delete();
      Navigator.pushNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      print('Error deleting user: ${e.message}');
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    _handleSignOut();
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final textTheme = theme.textTheme;
    FrameSize.init(context: context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.pink.shade800,
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        backgroundColor:
            Colors.transparent, // Transparent background for gradient
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
                Colors.blue.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.blue.shade200,
                width: 1,
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0, // Remove elevation shadow
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Poppins',
            letterSpacing: 1.2,
            color: Colors.blue.shade800,
          ),
          child: const Text("My Account"),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: IconButton(
              iconSize: FrameSize.screenWidth * 0.07,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Provider.of<ThemeProvider>(context).themeData == lightMode
                      ? Icons.brightness_7
                      : Icons.brightness_4,
                  key: ValueKey<bool>(
                      Provider.of<ThemeProvider>(context).themeData ==
                          lightMode),
                  color: Colors.blue.shade800,
                ),
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8E8F5),
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
            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: FrameSize.screenHeight * 0.03),
                      Container(
                        width: FrameSize.screenWidth * 0.18,
                        height: FrameSize.screenWidth *
                            0.18, // Make height equal to width
                        decoration: const BoxDecoration(
                          color: Color(0xFF545B63),
                          shape: BoxShape.circle, // Make the container circular
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: FrameSize.screenWidth * 0.09,
                        ),
                        // Lottie.asset('lib/images/user_new.json',
                        //     height: FrameSize.screenWidth * 0.18,
                        //     frameRate: const FrameRate(100),
                        //     repeat: false,
                        //     width: FrameSize.screenWidth * 0.18),
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              // Check if the connection is still loading
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }

                              // Handle error if the stream has an error
                              if (userSnapshot.hasError) {
                                return Text('Error: ${userSnapshot.error}');
                              }

                              // Check if the data exists in the snapshot
                              if (userSnapshot.hasData &&
                                  userSnapshot.data != null) {
                                var userData = userSnapshot.data!;
                                if (userData.exists) {
                                  // Safely access the 'name' field
                                  var name = userData['name'] ??
                                      'No name available'; // Fallback if 'name' is null
                                  return Text(
                                    name,
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 86, 122, 155),
                                      fontSize: FrameSize.screenWidth * 0.09,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ).animate().fade();
                                } else {
                                  return const Text(
                                      'User document does not exist');
                                }
                              } else {
                                return const Text('No data available');
                              }
                            },
                          ),
                          toEdit
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Change Name'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextArea(
                                                hintText: 'New Name',
                                                controller: changeName,
                                                obsureText: false,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                updateNewName(user);
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Success'),
                                                        content: const Text(
                                                            'Name has been updated successfully.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                toEdit =
                                                                    !toEdit;
                                                                user = FirebaseAuth
                                                                    .instance
                                                                    .currentUser;
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ).animate().fade(),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.01),
                      toEdit
                          ? ButtonTCS(
                              onTap: () {
                                toEdit = !toEdit;
                                setState(() {});
                              },
                              txtcolor: Colors.black,
                              txt: "Done",
                              color: const Color(0xffBDCFE7),
                            )
                          : ButtonTCS(
                              onTap: () {
                                toEdit = !toEdit;
                                setState(() {});
                              },
                              txtcolor: Colors.black,
                              txt: "Edit Profile",
                              color: const Color(0xffBDCFE7),
                            ),
                      SizedBox(height: FrameSize.screenHeight * 0.03),
                      Center(
                        child: SizedBox(
                          width: FrameSize.screenWidth * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // white background
                              borderRadius:
                                  BorderRadius.circular(20), // border radius
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // EMAIL LIST TILE STARTS HERE

                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        );
                                      }

                                      // Handle error if the stream has an error
                                      if (userSnapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'Error: ${userSnapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                        );
                                      }

                                      if (userSnapshot.hasData &&
                                          userSnapshot.data != null) {
                                        var userData = userSnapshot.data!;

                                        bool isGoogle =
                                            userData['authProvider'] ==
                                                'Google';

                                        return ListTile(
                                          subtitle: emailVerified
                                              ? const Text(
                                                  'Email Verified',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 14),
                                                )
                                              : Row(
                                                  children: [
                                                    const Text(
                                                      'Email Not Verified',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                        width: FrameSize
                                                                .screenWidth *
                                                            0.009),
                                                    GestureDetector(
                                                      onTap: verifyEmail,
                                                      child: const Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          trailing: toEdit &&
                                                  userData['authProvider'] !=
                                                      'Google'
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Change New Email',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'New Email Address',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                controller:
                                                                    newEmail,
                                                                obscureText:
                                                                    false,
                                                              ),
                                                              SizedBox(
                                                                  height: FrameSize
                                                                          .screenHeight *
                                                                      0.02),
                                                              TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Current Email Address',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                controller:
                                                                    oldEmail,
                                                                obscureText:
                                                                    false,
                                                              ),
                                                              SizedBox(
                                                                  height: FrameSize
                                                                          .screenHeight *
                                                                      0.02),
                                                              TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Password',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                controller:
                                                                    oldEmailPass,
                                                                obscureText:
                                                                    true,
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                updateNewEmail();
                                                                user = FirebaseAuth
                                                                    .instance
                                                                    .currentUser;
                                                                setState(() {
                                                                  toEdit =
                                                                      !toEdit;
                                                                });
                                                              },
                                                              child: const Text(
                                                                'Save',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                  ).animate().fade(),
                                                )
                                              : null,
                                          leading: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  105, 133, 140, 1),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.email,
                                              size:
                                                  FrameSize.screenWidth * 0.07,
                                              color: Colors.white,
                                            ),
                                          ),
                                          minLeadingWidth:
                                              FrameSize.screenWidth * 0.15,
                                          title:
                                              StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .snapshots(),
                                            builder: (context, userSnapshot) {
                                              if (userSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const SizedBox.shrink();
                                              }

                                              if (userSnapshot.hasError) {
                                                return Text(
                                                  'Error: ${userSnapshot.error}',
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14),
                                                );
                                              }

                                              if (userSnapshot.hasData &&
                                                  userSnapshot.data != null) {
                                                var userData =
                                                    userSnapshot.data!;
                                                if (userData.exists) {
                                                  var name =
                                                      userData['email'] ??
                                                          'No email available';
                                                  return Text(
                                                    name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ).animate().fade();
                                                } else {
                                                  return const Text(
                                                    'User document does not exist',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14),
                                                  );
                                                }
                                              } else {
                                                return const Text(
                                                  'No data available',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      }
                                      return const Center(
                                        child: Text(
                                          'No data available',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),
                                  // EMAIL LIST TILE END HERE
                                  _fadeDivider(),
                                  // THIS IS MOBILE NUMBER TILE

                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      // Check if the connection is still loading
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        );
                                      }

                                      // Handle error if the stream has an error
                                      if (userSnapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'Error: ${userSnapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                        );
                                      }

                                      // Check if the data exists in the snapshot
                                      if (userSnapshot.hasData &&
                                          userSnapshot.data != null) {
                                        var userData = userSnapshot.data!;
                                        String mobileNumber =
                                            userData['number'] ?? '';

                                        return ListTile(
                                          subtitle: const Text(
                                            'Phone Number',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                          trailing: toEdit
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Enter Phone Number',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: TextField(
                                                            controller:
                                                                phoneController,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Phone Number',
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                addPhoneNumber(
                                                                    user);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                'Save',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                  ).animate().fade(),
                                                )
                                              : mobileNumber.isEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Enter Phone Number',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    phoneController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Phone Number',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    addPhoneNumber(
                                                                        user);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Save',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .add_circle_outline_outlined,
                                                        size: FrameSize
                                                                .screenWidth *
                                                            0.095,
                                                        color: Colors.blue,
                                                      ).animate().fade(),
                                                    )
                                                  : null,
                                          leading: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  105, 133, 140, 1),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.phone,
                                              size:
                                                  FrameSize.screenWidth * 0.07,
                                              color: Colors.white,
                                            ),
                                          ),
                                          minLeadingWidth:
                                              FrameSize.screenWidth * 0.15,
                                          title: mobileNumber.isEmpty
                                              ? const Text(
                                                  'Not Available',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16),
                                                )
                                              : StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .snapshots(),
                                                  builder:
                                                      (context, userSnapshot) {
                                                    // Check if the connection is still loading
                                                    if (userSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }

                                                    // Handle error if the stream has an error
                                                    if (userSnapshot.hasError) {
                                                      return Text(
                                                        'Error: ${userSnapshot.error}',
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14),
                                                      );
                                                    }

                                                    // Check if the data exists in the snapshot
                                                    if (userSnapshot.hasData &&
                                                        userSnapshot.data !=
                                                            null) {
                                                      var userData =
                                                          userSnapshot.data!;
                                                      if (userData.exists) {
                                                        var number = userData[
                                                                'number'] ??
                                                            'No number available';
                                                        return Text(
                                                          number,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ).animate().fade();
                                                      } else {
                                                        return const Text(
                                                          'User document does not exist',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14),
                                                        );
                                                      }
                                                    } else {
                                                      return const Text(
                                                        'No data available',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14),
                                                      );
                                                    }
                                                  },
                                                ),
                                        );
                                      }
                                      return const Center(
                                        child: Text(
                                          'No data available',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),

                                  // MOBILE NUMBER TILE ENDS HERE
                                  _fadeDivider(),
                                  // THIS IS ADDRESS AREA TILE
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        );
                                      }

                                      if (userSnapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'Error: ${userSnapshot.error}',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                        );
                                      }

                                      if (userSnapshot.hasData &&
                                          userSnapshot.data != null) {
                                        var userData = userSnapshot.data!;
                                        String address =
                                            userData['address'] ?? '';

                                        return ListTile(
                                          subtitle: const Text(
                                            'Address',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                          trailing: toEdit
                                              ? GestureDetector(
                                                  onTap: () =>
                                                      _showAddressDialog(
                                                          context, user!),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Colors.blue,
                                                  ).animate().fade(),
                                                )
                                              : address.isEmpty
                                                  ? GestureDetector(
                                                      onTap: () =>
                                                          _showAddressDialog(
                                                              context, user!),
                                                      child: Icon(
                                                        Icons
                                                            .add_circle_outline_outlined,
                                                        size: FrameSize
                                                                .screenWidth *
                                                            0.095,
                                                        color: Colors.blue,
                                                      ).animate().fade(),
                                                    )
                                                  : null,
                                          leading: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(
                                                  105, 133, 140, 1),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.location_on,
                                              size:
                                                  FrameSize.screenWidth * 0.07,
                                              color: Colors.white,
                                            ),
                                          ),
                                          minLeadingWidth:
                                              FrameSize.screenWidth * 0.15,
                                          title: address.isEmpty
                                              ? const Text(
                                                  'Not Available',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16,
                                                  ),
                                                )
                                              : StreamBuilder<DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .snapshots(),
                                                  builder:
                                                      (context, userSnapshot) {
                                                    if (userSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const SizedBox
                                                          .shrink();
                                                    }

                                                    if (userSnapshot.hasError) {
                                                      return Text(
                                                        'Error: ${userSnapshot.error}',
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14),
                                                      );
                                                    }

                                                    if (userSnapshot.hasData &&
                                                        userSnapshot.data !=
                                                            null) {
                                                      var userData =
                                                          userSnapshot.data!;
                                                      return Text(
                                                        userData['address'] ??
                                                            'No address available',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ).animate().fade();
                                                    }
                                                    return const Text(
                                                      'No data available',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 14),
                                                    );
                                                  },
                                                ),
                                        );
                                      }
                                      return const Center(
                                        child: Text(
                                          'No data available',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),

                                  //ADDRESSS AREA ENDS HERE
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.025),
                      !isGoogle
                          ? SizedBox(
                              width: FrameSize.screenWidth * 0.8,
                              child: ButtonTCS(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Change New Email'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                height: FrameSize.screenHeight *
                                                    0.02),
                                            TextArea(
                                              hintText: 'Current Email',
                                              controller: oldEmail,
                                              obsureText: false,
                                            ),
                                            SizedBox(
                                                height: FrameSize.screenHeight *
                                                    0.02),
                                            TextArea(
                                              hintText: 'Old Password',
                                              controller: oldPass,
                                              obsureText: false,
                                            ),
                                            SizedBox(
                                                height: FrameSize.screenHeight *
                                                    0.02),
                                            TextArea(
                                              hintText: 'New Password',
                                              controller: newPass,
                                              obsureText: false,
                                            ),
                                            SizedBox(
                                                height: FrameSize.screenHeight *
                                                    0.02),
                                            TextArea(
                                              hintText: 'Confirm Password',
                                              controller: confirmPass,
                                              obsureText: true,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              updatePassword();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                txtcolor: Colors.black,
                                txt: 'CHANGE PASSWORD',
                                color: const Color(0xffBDCFE7),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: FrameSize.screenHeight * 0.025),
                      Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: FrameSize.screenHeight * 0.05),
                          SizedBox(
                            width: FrameSize.screenWidth * 0.4,
                            child: Container(
                              height: FrameSize.screenHeight * 0.07,
                              margin: EdgeInsets.symmetric(
                                horizontal: FrameSize.screenWidth * 0.001,
                              ),
                              child: ButtonTCS(
                                onTap: signUserOut,
                                txtcolor: Colors.white,
                                txt: 'Sign Out',
                                color: const Color.fromARGB(255, 86, 122, 155),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: FrameSize.screenWidth * 0.4,
                            child: Container(
                              height: FrameSize.screenHeight * 0.07,
                              margin: EdgeInsets.symmetric(
                                horizontal: FrameSize.screenWidth * 0.001,
                              ),
                              child: ButtonTCS(
                                onTap: deleteUser,
                                txt: 'Delete User',
                                txtcolor: Colors.white,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.05),
                      !emailVerified
                          ? SizedBox(
                              width: FrameSize.screenWidth * 0.8,
                              child: ButtonTCS(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/verification');
                                  },
                                  txt: 'Verify Email',
                                  color: Colors.amber,
                                  txtcolor: Colors.black))
                          : SizedBox(height: FrameSize.screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: FrameSize.screenWidth * 0.03,
          color: colorScheme.primary,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: FrameSize.screenWidth * 0.03,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(FrameSize.screenWidth * 0.02),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.home_rounded, size: FrameSize.screenWidth * 0.06),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(FrameSize.screenWidth * 0.02),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded,
                  size: FrameSize.screenWidth * 0.06),
            ),
            label: "Account",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/account_screen');
          }
        },
      ),
    );
  }

  Widget _fadeDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color.fromARGB(255, 86, 122, 155),
            Colors.transparent
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
