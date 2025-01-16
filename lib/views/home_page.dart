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
    FrameSize.init(context: context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: const Color(0xffF8E8F5),
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
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 1, // How wide the shadow spreads
                    blurRadius: 6, // Softness of the shadow
                    offset: const Offset(0, 1), // Position of the shadow (x, y)
                  ),
                ],
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(
                Icons.notifications,
                color: Color(0xffBDCFE7),
              ),
            ),
          ),
        ],
      ),
      //Body
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
                  // User Name and description
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi 👋🏻, ${user!.displayName ?? user!.email}',
                        style: TextStyle(
                            fontSize: FrameSize.screenWidth * 0.08,
                            color: const Color(0xff567A9B),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: FrameSize.screenHeight * 0.01,
                      ),
                      Text(
                        "Book your nursing care with just one click!",
                        style: TextStyle(
                            fontSize: FrameSize.screenWidth * 0.04,
                            color: const Color(0xff567A9B),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: FrameSize.screenHeight * 0.04,
                      ),

                      // Call now and Book now button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: FrameSize.screenWidth * 0.4,
                            child: Container(
                              height: FrameSize.screenHeight * 0.07,
                              margin: EdgeInsets.symmetric(
                                  horizontal: FrameSize.screenWidth * 0.001),
                              child: ButtonTCS(
                                onTap: () {
                                  // print("this is the output: $_hasCallSupport");
                                  if (_hasCallSupport) {
                                    setState(() {
                                      _launched = _makePhoneCall('1234567890');
                                    });
                                  } else {}
                                },
                                txt: "Call Now",
                                txtcolor: Colors.black,
                                color: const Color(0xffBDCFE7),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: FrameSize.screenWidth * 0.4,
                            child: Container(
                              height: FrameSize.screenHeight * 0.07,
                              margin: EdgeInsets.symmetric(
                                  horizontal: FrameSize.screenWidth * 0.001),
                              child: ButtonTCS(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/booking_screen');
                                },
                                txt: "Book Now",
                                txtcolor: Colors.black,
                                color: const Color(0xffB4D1B3),
                              ),
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffEEE1EF),
        selectedItemColor: const Color(0xff567A9B),
        unselectedItemColor: const Color(0xFF403E3E),
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
    );
  }
}
