import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs/services/booking_funtion.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/otp_form_field.dart';

class BookingConfirmationPagetwo extends StatefulWidget {
  final String serviceId;
  const BookingConfirmationPagetwo({super.key, required this.serviceId});

  @override
  State<BookingConfirmationPagetwo> createState() =>
      _BookingConfirmationPagetwoState();
}

class _BookingConfirmationPagetwoState
    extends State<BookingConfirmationPagetwo> {
  final BookingService _bookingService = BookingService();
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  final TextEditingController otpController5 = TextEditingController();
  final TextEditingController otpController6 = TextEditingController();
  late String enteredOtp;

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
                        // _bookingService.sendOTPEmail(email, otp);
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
                  _bookingService.confirmBooking(widget.serviceId, enteredOtp);
                  Navigator.pushNamed(context, '/');
                },
                txtcolor: colorScheme.onPrimary, // Button text color
                txt: 'Confirm Booking',
                color: colorScheme.primary, // Button background
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      ),
    );
  }
}
