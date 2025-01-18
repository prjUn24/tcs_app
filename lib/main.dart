import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs/theme/theme_provider.dart';
import 'package:tcs/views/booking_confirmation_page.dart';
import 'package:tcs/views/booking_page.dart';
import 'package:tcs/views/email_verification.dart';
import 'package:tcs/views/home_page.dart';
import 'package:tcs/views/login_page.dart';
import 'package:tcs/views/profile_page.dart';
import 'package:tcs/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tcs/views/test_temp.dart';
import 'firebase_options.dart';
// import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Return the AnimatedTheme widget to apply smooth transitions
        return AnimatedTheme(
          duration: const Duration(
              milliseconds: 300), // Duration for smooth transition
          curve: Curves.easeInOut, // Smooth curve for transition
          data: themeProvider
              .themeData, // Apply the current theme from the provider
          child: MaterialApp(
            theme: themeProvider
                .themeData, // The themeData comes from ThemeProvider
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginPage(),
              '/home': (context) => const HomePage(),
              '/booking_screen': (context) => const BookingPage(),
              '/account_screen': (context) => const ProfilePage(),
              '/verification': (context) => const EmailVerificationPage(),
              '/booking_confirmation_page': (context) =>
                  const BookingConfirmationPage(),
              '/test_temp': (context) => const App(),
            },
          ),
        );
      },
    );
  }
}
