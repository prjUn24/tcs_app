import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/views/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Center(
              child: Image.asset("lib/images/tcs.png"),
            ));
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  return const HomePage();
                } else {
                  return Center(
                    child: Image.asset("lib/images/tcs.png"),
                  ); //LoginOrRegisterPage();
                }
              },
            );
          } else {
            return Center(
              child: Image.asset("lib/images/tcs.png"),
            ); //LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
