// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/services/auth_service.dart';
import 'package:tcs/views/forgot_password.dart';
// import 'package:tcs/views/registration.dart';
// import 'package:tcs/views/splash_screen.dart';
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

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code.isNotEmpty) {
        wrongCredentials();
      }
    }
  }

  void wrongCredentials() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Credentials'),
        content: const Text('The Email or password you have entered is wrong'),
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
            // heightFactor: 1.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'lib/images/tcs.png',
                  scale: 1.5,
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextArea(
                      obsureText: false,
                      hintText: 'Email',
                      controller: emailController,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextArea(
                      obsureText: true,
                      hintText: 'Password',
                      controller: passwordController,
                    )),
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
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // const Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 30),
                //     child: ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ButtonTCS(
                    txt: 'L O G I N',
                    onTap: signUserIn,
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
                  height: 30,
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: Colors.blue),
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
