import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/views/booking_funtion.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/otp_form_field.dart';
// import 'package:tcs/widgets/text_area.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  final BookingService _bookingService = BookingService();

  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  final TextEditingController otpController5 = TextEditingController();
  final TextEditingController otpController6 = TextEditingController();

  // final TextEditingController otpController = TextEditingController();

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
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                    end: 0,
                    start: 0,
                    top: 0,
                    bottom: FrameSize.screenHeight * 0.09),
                child: Lottie.asset('lib/images/otp.json',
                    height: FrameSize.screenHeight * 0.30),
              ),
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
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OtpFormField(
                      otpValue: otpController1,
                    ),
                    OtpFormField(
                      otpValue: otpController2,
                    ),
                    OtpFormField(
                      otpValue: otpController3,
                    ),
                    OtpFormField(
                      otpValue: otpController4,
                    ),
                    OtpFormField(
                      otpValue: otpController5,
                    ),
                    OtpFormField(
                      otpValue: otpController6,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: FrameSize.screenHeight * 0.008,
              ),
              Padding(
                padding: EdgeInsets.only(right: FrameSize.screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Didn't Receive OTP?,"),
                    SizedBox(width: FrameSize.screenWidth * 0.025),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Re-send',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: FrameSize.screenHeight * 0.05,
              ),
              ButtonTCS(
                onTap: () {
                  _fetchServiceId();
                  _bookingService.confirmBooking(
                      serviceId!,
                      otpController1.text +
                          otpController2.text +
                          otpController3.text +
                          otpController4.text +
                          otpController5.text +
                          otpController6.text);
                  Navigator.pushNamed(context, "/home");
                },
                txtcolor: Colors.black,
                txt: 'Confirm Booking',
                color: const Color(0xffB4D1B3),
              ),
              const SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
