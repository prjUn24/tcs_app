import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcs/views/booking_page.dart';
import 'package:tcs/views/home_page.dart';
import 'package:tcs/views/login_page.dart';
import 'package:tcs/views/profile_page.dart';
import 'package:tcs/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_animate/flutter_animate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen()
            .animate()
            .fade(duration: const Duration(milliseconds: 100)),
        '/login': (context) => const LoginPage()
            .animate()
            .fade(duration: const Duration(milliseconds: 100)),
        '/home': (context) => const HomePage()
            .animate()
            .fade(duration: const Duration(milliseconds: 100)),
        '/booking_screen': (context) => const BookingPage()
            .animate()
            .fade(duration: const Duration(milliseconds: 100)),
        '/account_screen': (context) => const ProfilePage()
            .animate()
            .fade(duration: const Duration(milliseconds: 100)),
      },
    );
  }
}
