import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/services/fetch_booking.dart';
import 'package:tcs/services/push_notification_service.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/appbar.dart';
import 'package:tcs/widgets/booking_details.dart';
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

  PushNotificationService _notificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();
    _checkCallSupport();
    _notificationService
        .setupLocalNotifications(); // Initialize local notifications
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
      backgroundColor: colorScheme.background,
      appBar: const GradientAppBarWidget(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              margin: EdgeInsets.all(FrameSize.screenWidth * 0.04),
              padding: EdgeInsets.symmetric(
                horizontal: FrameSize.screenWidth * 0.04,
                vertical: FrameSize.screenHeight * 0.03,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: .09),
                    Colors.black.withValues(alpha: .55),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(FrameSize.screenWidth * 0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.waving_hand_rounded,
                          color: colorScheme.primary,
                          size: FrameSize.screenWidth * 0.07),
                      SizedBox(width: FrameSize.screenWidth * 0.03),
                      Expanded(
                        child: Text(
                          'Hi ${user!.displayName ?? user!.email ?? 'User'}!',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
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
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
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
                            width: buttonWidth,
                            height: buttonHeight,
                            icon: Icons.phone_in_talk_rounded,
                            label: "Call Now",
                            color: colorScheme.primary,
                            onPressed: () =>
                                _hasCallSupport ? _makePhoneCall('123') : null,
                          ),
                          _buildResponsiveButton(
                            width: buttonWidth,
                            height: buttonHeight,
                            icon: Icons.calendar_month_rounded,
                            label: "Book Now",
                            color: colorScheme.secondary,
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
                  horizontal: FrameSize.screenWidth * 0.04),
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
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.015),
                  const BookingDetails(),
                ],
              ),
            ),
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
              color: color.withOpacity(0.15),
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
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.home_rounded, size: FrameSize.screenWidth * 0.06),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(FrameSize.screenWidth * 0.02),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded,
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
