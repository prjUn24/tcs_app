import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  EmailVerificationPageState createState() => EmailVerificationPageState();
}

class EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isEmailVerified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _checkEmailVerified();
  }

  Future<void> _checkEmailVerified() async {
    await _user?.reload();
    _user = _auth.currentUser;
    setState(() {
      _isEmailVerified = _user?.emailVerified ?? false;
    });
    if (_isEmailVerified) {
      _updateEmailVerifiedStatus(true);
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _user?.sendEmailVerification();
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent')),
      );

      Navigator.pushNamed(context, '/');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send verification email')),
      );
    }
  }

  Future<void> _updateEmailVerifiedStatus(bool isVerified) async {
    if (_user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({'emailVerified': isVerified});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _isEmailVerified
                ? const Text('Your email is verified')
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Please verify your email'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _sendVerificationEmail,
                        child: const Text('Send Verification Email'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
