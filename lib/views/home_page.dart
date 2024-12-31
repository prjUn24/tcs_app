// ignore_for_file: sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcs/widgets/booking_details.dart';
import 'package:tcs/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5FAF9),
      appBar: AppBar(
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
                    color: Colors.grey
                        .withValues(alpha: 0.5), // Shadow color with opacity
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
      body: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              height: 200, // Specify a height for the container
              width: double.infinity,
              // User Name and description
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi, Shahab 👋",
                    style: TextStyle(
                        fontSize: 33.55,
                        color: Color(0xff567A9B),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text(
                    "Book your nursing care with just one click!",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xff567A9B),
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),

                  // Call now and Book now button
                  Flexible(
                    child: Row(
                      spacing: 15.0,
                      children: [
                        ButtonTCS(
                          onTap: () {},
                          txt: "Call Now",
                          color: const Color(0xffBDCFE7),
                        ),
                        ButtonTCS(
                          onTap: () {
                            setState(() {
                              Navigator.pushNamed(context, '/booking_screen');
                            });
                          },
                          txt: "Book Now",
                          color: const Color(0xffB4D1B3),
                        ),
                      ],
                    ),
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
            const SizedBox(height: 30),
            ButtonTCS(
              onTap: signUserOut,
              txt: 'SIGN OUT',
              color: const Color(0xffBDCFE7),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xffEEE1EF),
          selectedItemColor: const Color(0xff567A9B),
          unselectedItemColor: const Color(0xFF403E3E),
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
          ]),
    );
  }
}
