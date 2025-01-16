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

  // Method to check if email is verified.
  void isEmailVerified() {
    setState(() {
      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    print("This is the output of email Verification: $emailVerified");
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
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    FrameSize.init(context: context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: const Icon(Icons.arrow_back_ios_outlined)),
        backgroundColor: const Color(0xffF8E8F5),
        centerTitle: true,
        actions: [
          IconButton(
            iconSize: FrameSize.screenWidth * 0.09,
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeData == lightMode
                  ? Icons.brightness_7 // Sun Icon for light mode
                  : Icons.brightness_4, // Moon Icon for dark mode
              color: Colors.black.withAlpha(150),
            ),
            onPressed: () {
              // Toggle theme when icon is pressed
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          )
        ],
        title: const Text(
          "My Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // StreamBuilder<DocumentSnapshot>(
                //   stream: FirebaseFirestore.instance
                //       .collection('users')
                //       .doc(user!.uid)
                //       .snapshots(),
                //   builder: (context, userSnapshot) {
                //     return Text(userSnapshot.data?['name']);
                //   },
                // ),
                Lottie.asset('lib/images/user_new.json',
                    frameRate: const FrameRate(100),
                    repeat: false,
                    width: FrameSize.screenWidth * 0.2),
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
                        if (userSnapshot.hasData && userSnapshot.data != null) {
                          var userData = userSnapshot.data!;
                          if (userData.exists) {
                            // Safely access the 'name' field
                            var name = userData['name'] ??
                                'No name available'; // Fallback if 'name' is null
                            return Text(
                              name,
                              style: TextStyle(
                                fontSize: FrameSize.screenWidth * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fade();
                          } else {
                            return Text('User document does not exist');
                          }
                        } else {
                          return Text('No data available');
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
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Success'),
                                                  content: const Text(
                                                      'Name has been updated successfully.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          toEdit = !toEdit;
                                                          user = FirebaseAuth
                                                              .instance
                                                              .currentUser;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
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
                            child: const Icon(Icons.edit).animate().fade(),
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
                SizedBox(height: FrameSize.screenHeight * 0.009),

                // EMAIL LIST TILE STARTS HERE

                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    // Handle error if the stream has an error
                    if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    }
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      var userData = userSnapshot.data!;

                      isGoogle = userData['authProvider'] == 'Google';

                      // String email = userData['email'] ?? '';
                      return ListTile(
                        subtitle: emailVerified
                            ? const Text('Email')
                            : Row(
                                children: [
                                  const Text('Not Verified'),
                                  SizedBox(
                                      width: FrameSize.screenWidth * 0.009),
                                  GestureDetector(
                                      onTap: verifyEmail,
                                      child: const Icon(Icons.error_outline))
                                ],
                              ),
                        trailing: toEdit && userData['authProvider'] != 'Google'
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Change New Email'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextArea(
                                              hintText: 'New Email Address',
                                              controller: newEmail,
                                              obsureText: false,
                                            ),
                                            SizedBox(
                                                height: FrameSize.screenHeight *
                                                    0.02),
                                            TextArea(
                                              hintText: 'Current Email Address',
                                              controller: oldEmail,
                                              obsureText: false,
                                            ),
                                            SizedBox(
                                                height: FrameSize.screenHeight *
                                                    0.02),
                                            TextArea(
                                              hintText: 'Password',
                                              controller: oldEmailPass,
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
                                              updateNewEmail();
                                              user = FirebaseAuth
                                                  .instance.currentUser;
                                              setState(() {
                                                toEdit = !toEdit;
                                              });
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.edit).animate().fade(),
                              )
                            : null,
                        leading: Icon(
                          Icons.email,
                          size: FrameSize.screenWidth * 0.09,
                        ),
                        minLeadingWidth: FrameSize.screenWidth * 0.15,
                        title: StreamBuilder<DocumentSnapshot>(
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
                                var name = userData['email'] ??
                                    'No name available'; // Fallback if 'name' is null
                                return Text(
                                  name,
                                ).animate().fade();
                              } else {
                                return Text('User document does not exist');
                              }
                            } else {
                              return Text('No data available');
                            }
                          },
                        ),
                      );
                    }
                    return const Text('No data available');
                  },
                ),

                // EMAIL LIST TILE END HERE

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
                      return const SizedBox.shrink();
                    }

                    // Handle error if the stream has an error
                    if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    }

                    // Check if the data exists in the snapshot
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      var userData = userSnapshot.data!;
                      false; // Assuming 'toEdit' is a boolean field that controls edit mode
                      String mobileNumber = userData['number'] ?? '';

                      return ListTile(
                        subtitle: const Text('Phone Number'),
                        trailing: toEdit
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Enter Phone Number'),
                                        content: TextField(
                                          controller: phoneController,
                                          decoration: const InputDecoration(
                                            hintText: 'Phone Number',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              addPhoneNumber(user);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.edit).animate().fade())
                            : mobileNumber == ''
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Enter Phone Number'),
                                            content: TextField(
                                              controller: phoneController,
                                              decoration: const InputDecoration(
                                                hintText: 'Phone Number',
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  addPhoneNumber(user);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.add_circle_outline_outlined,
                                      size: FrameSize.screenWidth * 0.095,
                                    ).animate().fade(),
                                  )
                                : null,
                        leading: Icon(
                          Icons.phone,
                          size: FrameSize.screenWidth * 0.09,
                        ),
                        minLeadingWidth: FrameSize.screenWidth * 0.15,
                        title: mobileNumber == ''
                            ? const Text('Not Available')
                            : StreamBuilder<DocumentSnapshot>(
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
                                      var name = userData['number'] ??
                                          'No name available'; // Fallback if 'name' is null
                                      return Text(
                                        name,
                                      ).animate().fade();
                                    } else {
                                      return Text(
                                          'User document does not exist');
                                    }
                                  } else {
                                    return Text('No data available');
                                  }
                                },
                              ),
                      );
                    }
                    return const Text('No data available');
                  },
                ),

                // THIS IS ADDRESS AREA TILE

                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }

                    // Handle error if the stream has an error
                    if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    }

                    // Check if the data exists in the snapshot
                    if (userSnapshot.hasData && userSnapshot.data != null) {
                      var userData = userSnapshot.data!;
                      String address = userData['address'] ?? '';
                      return ListTile(
                        subtitle: const Text('Address'),
                        trailing: toEdit
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Enter Address'),
                                        content: TextField(
                                          controller: addressController,
                                          decoration: const InputDecoration(
                                            hintText: 'Address',
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              updateAddress(user);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.edit).animate().fade())
                            : address.isEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Enter Address'),
                                            content: TextField(
                                              controller: addressController,
                                              decoration: const InputDecoration(
                                                hintText: 'Address',
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  updateAddress(user);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Enter Address'),
                                              content: TextField(
                                                controller: addressController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Address',
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    updateAddress(user);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.add_circle_outline_outlined,
                                        size: FrameSize.screenWidth * 0.095,
                                      ).animate().fade(),
                                    ),
                                  )
                                : null,
                        leading: Icon(
                          Icons.home,
                          size: FrameSize.screenWidth * 0.09,
                        ),
                        minLeadingWidth: FrameSize.screenWidth * 0.15,
                        title: address == ''
                            ? const Text('Not Available')
                            : StreamBuilder<DocumentSnapshot>(
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
                                      var name = userData['address'] ??
                                          'No name available'; // Fallback if 'name' is null
                                      return Text(
                                        name,
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
                      );
                    }
                    return const Text('No data available');
                  },
                ),

                //ADDRESSS AREA ENDS HERE

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
                                          height:
                                              FrameSize.screenHeight * 0.02),
                                      TextArea(
                                        hintText: 'Current Email',
                                        controller: oldEmail,
                                        obsureText: false,
                                      ),
                                      SizedBox(
                                          height:
                                              FrameSize.screenHeight * 0.02),
                                      TextArea(
                                        hintText: 'Old Password',
                                        controller: oldPass,
                                        obsureText: false,
                                      ),
                                      SizedBox(
                                          height:
                                              FrameSize.screenHeight * 0.02),
                                      TextArea(
                                        hintText: 'New Password',
                                        controller: newPass,
                                        obsureText: false,
                                      ),
                                      SizedBox(
                                          height:
                                              FrameSize.screenHeight * 0.02),
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
                          txtcolor: Colors.black,
                          txt: 'SIGN OUT',
                          color: const Color(0xffBDCFE7),
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
                          txt: 'DELETE USER',
                          txtcolor: Colors.red,
                          color: const Color(0xffBDCFE7),
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
                              Navigator.pushNamed(context, '/verification');
                            },
                            txt: 'Verify Email',
                            color: Colors.amber,
                            txtcolor: Colors.black),
                      )
                    : SizedBox(height: FrameSize.screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: const Color(0xffEEE1EF),
        selectedItemColor: const Color(0xff567A9B),
        unselectedItemColor: const Color(0xFF403E3E),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: "Account",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/account_screen');
          }
        },
      ),
    );
  }
}
