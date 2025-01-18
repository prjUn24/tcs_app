import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcs/views/booking_funtion.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/text_area.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  final BookingService _bookingService = BookingService();
  final TextEditingController otpController = TextEditingController();

  String? serviceId;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchServiceId() async {
    final bookingData = await FirebaseFirestore.instance
        .collection('bookings')
        .doc('your_booking_document_id')
        .get();
    setState(() {
      serviceId = bookingData['serviceId'];
    });
    debugPrint(serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5FAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8E8F5),
        centerTitle: true,
        title: const Text(
          "Booking Confirmation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Confirm your care booking by verifying the OTP that is sent to your given mobile number:",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextArea(
              hintText: 'OTP',
              controller: otpController,
              obsureText: false,
            ),
            const SizedBox(
              height: 25.0,
            ),
            ButtonTCS(
              onTap: () {
                setState(() async {
                  await _fetchServiceId();
                  await _bookingService.confirmBooking(
                      serviceId!, otpController.text);
                  Navigator.pushNamed(context, "/home");
                });
              },
              txtcolor: Colors.black,
              txt: 'Confirm Booking',
              color: const Color(0xffB4D1B3),
            ),
            const SizedBox(
              height: 25.0,
            ),
            ButtonTCS(
              onTap: () {},
              txt: 'Send OTP',
              txtcolor: Colors.black,
              color: const Color(0xffBDCFE7),
            ),
          ],
        ),
      ),
    );
  }
}
