// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/services/fetch_booking.dart';
import 'package:tcs/services/push_notification_service.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/booking_details.dart';
// import 'package:tcs/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final firestoreService = FirestoreService();
  bool _hasCallSupport = false;

  final PushNotificationService _notificationService =
      PushNotificationService();

  @override
  void initState() {
    super.initState();
    _checkCallSupport();
    _notificationService.setupLocalNotifications();
  }

  void _checkCallSupport() async {
    final result = await canLaunchUrl(Uri(scheme: 'tel', path: '123'));
    setState(() => _hasCallSupport = result);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    FrameSize.init(context: context);

    return Scaffold(
      backgroundColor: const Color(0xffF8E8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8E8F5),
        elevation: 4.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            "lib/images/heart-logo.png",
            width: 40.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.history,
                color: Colors.white,
              ),
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(
                  Color(
                    0xffA7C9D3,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              margin: EdgeInsets.all(FrameSize.screenWidth * 0.06),
              padding: EdgeInsets.symmetric(
                horizontal: FrameSize.screenWidth * 0.04,
                vertical: FrameSize.screenHeight * 0.03,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 1, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: const Offset(2, 2), // Shadow offset (x, y)
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(FrameSize.screenWidth * 0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.waving_hand_rounded,
                          color: Colors.amber,
                          size: FrameSize.screenWidth * 0.07),
                      SizedBox(width: FrameSize.screenWidth * 0.03),
                      Expanded(
                        child: Text(
                          'Hi ${user!.displayName ?? user!.email ?? 'User'}!',
                          style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff567A9B),
                              fontSize: 25.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.015),
                  Text(
                    "Get quality nursing care with just one tap!",
                    style: textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.04),
                  // Responsive Button Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final buttonWidth = constraints.maxWidth * 0.45;
                      final buttonHeight = FrameSize.screenHeight * 0.065;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildResponsiveButton(
                            buttonColor: const Color(0xff567A9B),
                            width: buttonWidth,
                            height: buttonHeight,
                            icon: Icons.phone_in_talk_rounded,
                            label: "Call Now",
                            color: Colors.white,
                            onPressed: () =>
                                _hasCallSupport ? _makePhoneCall('123') : null,
                          ),
                          _buildResponsiveButton(
                            buttonColor: const Color(0xff69858C),
                            width: buttonWidth,
                            height: buttonHeight,
                            icon: Icons.calendar_month_rounded,
                            label: "Book Now",
                            color: Colors.white,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/booking_screen'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Services Section
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: FrameSize.screenWidth * 0.04,
                  vertical: FrameSize.screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: FrameSize.screenWidth * 0.02),
                    child: Text(
                      "Your Bookings",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.01),
                  const BookingDetails(),
                ],
              ),
            ),
            // ButtonTCS(
            //     onTap: () {
            //       Navigator.pushNamed(context, '/test_temp');
            //     },
            //     txt: 'Test Button',
            //     color: Colors.amberAccent,
            //     txtcolor: Colors.black)
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildResponsiveButton({
    required double width,
    required double height,
    required IconData icon,
    required String label,
    required Color color,
    required Color buttonColor,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.03),
        elevation: 4,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.03),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: FrameSize.screenWidth * 0.02,
            ),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.03),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: FrameSize.screenWidth * 0.06),
                SizedBox(width: FrameSize.screenWidth * 0.02),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: FrameSize.screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: FrameSize.screenWidth * 0.03,
            spreadRadius: FrameSize.screenWidth * 0.01,
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 10,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        currentIndex: 0,
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
              decoration: const BoxDecoration(
                color: Color(0xff567A9B),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home_filled,
                  color: Colors.white, size: FrameSize.screenWidth * 0.06),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(FrameSize.screenWidth * 0.02),
              decoration: const BoxDecoration(
                color: Color(0xffA5B7C7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded,
              color: Colors.white,
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
}
