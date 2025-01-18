import 'package:flutter/material.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo EmailJS',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const TestPage(title: 'Flutter Demo EmailJS'),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.title});
  final String title;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  void _sendEmail() async {
    try {
      await emailjs.send(
        'service_govjhro',
        'template_05wzkxw',
        {
          'to_email': 'fattah321vip@gmail.com',
          'message': 'Hi, TESTING THIS EMAILJS SERVICE',
        },
        const emailjs.Options(
          publicKey: 'eYY99_Le6wSfDqOuv',
          privateKey: 'koezZZk2G8cUUA4wjE-B0',
          limitRate: emailjs.LimitRate(
            id: 'app',
            throttle: 10000,
          ),
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        print('ERROR... $error');
      }
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press "Send Email" to send email',
            ),
            ElevatedButton(
              onPressed: _sendEmail,
              child: const Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
