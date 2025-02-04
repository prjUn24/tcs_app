import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/services/booking_funtion.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/otp_form_field.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? serviceId = "";
  String otp = "";
  String email = "";
  late String enteredOtp;

  @override
  void initState() {
    super.initState();
    _fetchServiceId();
  }

  Future<void> _fetchServiceId() async {
    try {
      final currentUserData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      // Retrieve the 'services' array from the document
      final List<dynamic>? currentUserServiceData =
          currentUserData.data()?['services'];

      if (currentUserServiceData != null && currentUserServiceData.isNotEmpty) {
        // Extract the last service object from the array
        final Map<String, dynamic> lastService =
            currentUserServiceData[currentUserServiceData.length - 1];

        // Extract the serviceId field from the last service
        setState(() {
          email = currentUserData.data()?['email'] as String;
          serviceId = lastService['serviceId'] as String?;
          otp = lastService['otp'] as String;
        });
        debugPrint("Service ID: $serviceId");
        debugPrint("Email: $email");
      } else {
        debugPrint("No services found for the user.");
      }
    } catch (e) {
      debugPrint("Error fetching serviceId: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorScheme.surface, // Use surface for background
      appBar: AppBar(
        backgroundColor: colorScheme.primary, // Primary color for AppBar
        centerTitle: true,
        title: Text(
          "Booking Confirmation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary, // Text color on AppBar
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
                  bottom: FrameSize.screenHeight * 0.09,
                ),
                child: Lottie.asset(
                  'lib/images/otp.json',
                  height: FrameSize.screenHeight * 0.30,
                ),
              ),
              Text(
                "Confirm your care booking by verifying the OTP that is sent to your given mobile number:",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface, // Text color
                ),
              ),
              const SizedBox(height: 30.0),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OtpFormField(otpValue: otpController1),
                    OtpFormField(otpValue: otpController2),
                    OtpFormField(otpValue: otpController3),
                    OtpFormField(otpValue: otpController4),
                    OtpFormField(otpValue: otpController5),
                    OtpFormField(otpValue: otpController6),
                  ],
                ),
              ),
              SizedBox(height: FrameSize.screenHeight * 0.008),
              Padding(
                padding: EdgeInsets.only(right: FrameSize.screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Didn't Receive OTP?,",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    SizedBox(width: FrameSize.screenWidth * 0.025),
                    GestureDetector(
                      onTap: () {
                        _bookingService.sendOTPEmail(email, otp);
                      },
                      child: Text(
                        'Re-send',
                        style: TextStyle(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: FrameSize.screenHeight * 0.05),
              ButtonTCS(
                onTap: () {
                  enteredOtp = otpController1.text +
                      otpController2.text +
                      otpController3.text +
                      otpController4.text +
                      otpController5.text +
                      otpController6.text;
                  debugPrint("Entered OTP: $enteredOtp");
                  _bookingService.confirmBooking(serviceId!, enteredOtp);
                  Navigator.pushNamed(context, '/');
                },
                txtcolor: colorScheme.onPrimary, // Button text color
                txt: 'Confirm Booking',
                color: colorScheme.primary, // Button background
              ),
              const SizedBox(height: 25.0),
              ButtonTCS(
                onTap: () {
                  _fetchServiceId();
                  print("______________________");
                },
                txtcolor: colorScheme.onPrimary, // Button text color
                txt: 'TEST',
                color: colorScheme.error, // Button background
              ),
            ],
          ),
        ),
      ),
    );
  }
}
