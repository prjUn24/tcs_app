import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/widgets/button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Image(
                width: 180.0,
                image: AssetImage(
                  'lib/images/tcs.png',
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Circular progress indicator
            const SizedBox(height: 30),
            Text('Logged in as ${user.email!}'),
            const SizedBox(height: 30),
            ButtonTCS(
              onTap: signUserOut,
              txt: 'SIGN OUT',
            )
          ],
        ));
  }
}
