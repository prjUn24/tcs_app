import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/booking_details.dart';
import 'package:tcs/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  bool _hasCallSupport = false;
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    FrameSize.init(context: context);

    return Scaffold(
      backgroundColor: colorScheme.background,

      // Use background for the main page
      appBar: AppBar(
        elevation: 50,
        shadowColor: colorScheme.surface,
        leading: const SizedBox.shrink(),
        centerTitle: true,
        backgroundColor:
            colorScheme.onPrimary.withAlpha(90), // Primary color for AppBar
        title: const Image(
          width: 80.0,
          image: AssetImage(
            "lib/images/tcs.png",
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            padding: const EdgeInsets.only(right: 16.0),
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface
                        .withOpacity(0.1), // Subdued shadow
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
                color: colorScheme
                    .surface, // Surface for notification icon background
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                Icons.notifications,
                color: colorScheme.secondary, // Secondary color for the icon
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: FrameSize.screenWidth * 0.05,
                    vertical: FrameSize.screenHeight * 0.02,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi 👋🏻, ${user!.displayName ?? user!.email ?? 'User'}',
                        style: TextStyle(
                          fontSize: FrameSize.screenWidth * 0.08,
                          color: colorScheme
                              .onBackground, // Use onBackground for greeting
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.01),
                      Text(
                        "Book your nursing care with just one click!",
                        style: TextStyle(
                          fontSize: FrameSize.screenWidth * 0.04,
                          color: colorScheme.onBackground
                              .withOpacity(0.7), // Subdued text
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: FrameSize.screenWidth * 0.4,
                            child: ButtonTCS(
                              onTap: () {
                                if (_hasCallSupport) {
                                  setState(() {
                                    _launched = _makePhoneCall('1234567890');
                                  });
                                }
                              },
                              txt: "Call Now",
                              txtcolor:
                                  colorScheme.onPrimary, // Button text color
                              color: colorScheme.primary, // Button background
                            ),
                          ),
                          SizedBox(
                            width: FrameSize.screenWidth * 0.4,
                            child: ButtonTCS(
                              onTap: () {
                                Navigator.pushNamed(context, '/booking_screen');
                              },
                              txt: "Book Now",
                              txtcolor:
                                  colorScheme.onPrimary, // Button text color
                              color: colorScheme.secondary, // Button background
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const BookingDetails(
                  title: "Upcoming Bookings:",
                  bookingStatus: "You have 1 upcoming booking.",
                ),
                const BookingDetails(
                  title: "Pending Bookings:",
                  bookingStatus: "You have 1 pending booking.",
                ),
                ButtonTCS(
                  onTap: () {
                    Navigator.pushNamed(context, '/test_temp');
                  },
                  txt: 'TEST',
                  txtcolor: colorScheme.onPrimary,
                  color: colorScheme.primary,
                ),
                ButtonTCS(
                  onTap: () {
                    Navigator.pushNamed(context, '/booking_confirmation_page');
                  },
                  txt: 'Navigate',
                  txtcolor: colorScheme.onPrimary,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        // elevation: 90,
        color: colorScheme.onPrimary.withAlpha(90),
        shadowColor: colorScheme.secondary,
        child: BottomNavigationBar(
          elevation: 50,
          backgroundColor: Colors.transparent, // Surface for background
          selectedItemColor: colorScheme.primary, // Primary for selected item
          unselectedItemColor:
              colorScheme.onSurface.withOpacity(0.6), // Subdued for unselected
          currentIndex: 0,
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
              Navigator.pushNamed(context, '/');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/account_screen');
            }
          },
        ),
      ),
    );
  }
}
