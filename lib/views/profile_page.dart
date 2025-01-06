import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final newEmail = TextEditingController();
  final oldEmail = TextEditingController();
  final oldEmailPass = TextEditingController();

  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  final changeName = TextEditingController();

  bool toEdit = false;

  @override
  void initState() {
    super.initState();
  }

  void updateNewName() async {
    try {
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(changeName.text);
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

  void addPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        print('Verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Verification code sent: $verificationId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Auto retrieval timeout: $verificationId");
      },
    );
  }

  void deleteUser() async {
    try {
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
        backgroundColor: const Color(0xffF8E8F5),
        centerTitle: true,
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
                Lottie.asset('lib/images/user.json',
                    width: FrameSize.screenWidth * 0.35),
                SizedBox(height: FrameSize.screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user!.displayName ?? user!.email!,
                      style: TextStyle(
                        fontSize: FrameSize.screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fade(),
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
                                          updateNewName();
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
                Container(
                  height: FrameSize.screenHeight * 0.05,
                  margin: EdgeInsets.symmetric(
                    horizontal: FrameSize.screenWidth * 0.35,
                  ),
                  child: toEdit
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
                ),
                SizedBox(height: FrameSize.screenHeight * 0.05),
                ListTile(
                  subtitle: const Text('Email'),
                  trailing: toEdit
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
                                          height:
                                              FrameSize.screenHeight * 0.02),
                                      TextArea(
                                        hintText: 'Current Email Address',
                                        controller: oldEmail,
                                        obsureText: false,
                                      ),
                                      SizedBox(
                                          height:
                                              FrameSize.screenHeight * 0.02),
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
                                        user =
                                            FirebaseAuth.instance.currentUser;
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
                  title: Text('${user!.email}'),
                ),
                ListTile(
                  subtitle: const Text('Phone Number'),
                  trailing: toEdit
                      ? const Icon(Icons.edit).animate().fade()
                      : user!.phoneNumber == null
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
                                            addPhoneNumber();
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
                          : Text('${user!.phoneNumber}'),
                  leading: Icon(
                    Icons.phone,
                    size: FrameSize.screenWidth * 0.09,
                  ),
                  minLeadingWidth: FrameSize.screenWidth * 0.15,
                  title: user!.phoneNumber == ''
                      ? const Text('Not Available')
                      : Text('${user!.phoneNumber}'),
                ),
                SizedBox(height: FrameSize.screenHeight * 0.025),
                Container(
                  height: FrameSize.screenHeight * 0.07,
                  margin: EdgeInsets.symmetric(
                    horizontal: FrameSize.screenWidth * 0.08,
                  ),
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
                                SizedBox(height: FrameSize.screenHeight * 0.02),
                                TextArea(
                                  hintText: 'Current Email',
                                  controller: oldEmail,
                                  obsureText: false,
                                ),
                                SizedBox(height: FrameSize.screenHeight * 0.02),
                                TextArea(
                                  hintText: 'Old Password',
                                  controller: oldPass,
                                  obsureText: false,
                                ),
                                SizedBox(height: FrameSize.screenHeight * 0.02),
                                TextArea(
                                  hintText: 'New Password',
                                  controller: newPass,
                                  obsureText: false,
                                ),
                                SizedBox(height: FrameSize.screenHeight * 0.02),
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
                ),
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
                )
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
