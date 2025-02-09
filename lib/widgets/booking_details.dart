// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:tcs/services/booking_funtion.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:tcs/services/fetch_booking.dart';
import 'package:tcs/views/booking_confirmation_pagetwo.dart';
import 'package:tcs/views/width_and_height.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tcs/widgets/bottomsheet.dart';
// import 'package:tcs/widgets/button.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({super.key});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOTPEmail(String otp) async {
    try {
      String email = _auth.currentUser!.email!;
      await emailjs.send(
        'service_govjhro',
        'template_05wzkxw',
        {
          'to_email': email,
          'message': 'Your Booking OTP for HomeCare is $otp',
        },
        const emailjs.Options(
          publicKey: 'eYY99_Le6wSfDqOuv',
          privateKey: 'koezZZk2G8cUUA4wjE-B0',
        ),
      );
      Fluttertoast.showToast(msg: "OTP sent to $email");
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to send OTP: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FrameSize.screenWidth * 0.04,
        vertical: FrameSize.screenHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: 'Confirmed Bookings',
            colorScheme: colorScheme,
          ),
          SizedBox(height: FrameSize.screenHeight * 0.015),
          _buildServicesContainer(
            stream: firestoreService.fetchServices(),
            filter: (service) => service['status'] == "assigned",
            emptyMessage: 'No confirmed bookings',
            colorScheme: colorScheme,
            buildTrailing: (value) =>
                value['payment'].toString().toLowerCase() == "done"
                    ? Icon(Icons.check_circle_outline,
                        color: Colors.green, size: FrameSize.screenWidth * 0.06)
                    : _buildPaymentButton(),
          ),
          SizedBox(height: FrameSize.screenHeight * 0.04),
          _buildSectionHeader(
            title: 'Pending Requests',
            colorScheme: colorScheme,
          ),
          SizedBox(height: FrameSize.screenHeight * 0.015),
          _buildServicesContainer(
            stream: firestoreService.fetchServices(),
            filter: (service) => service['status'] != "assigned",
            emptyMessage: 'No pending requests',
            colorScheme: colorScheme,
            buildTrailing: (value) => value['status'] != 'Confirmed'
                ? _buildVerifyButton(value)
                : _buildPendingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required ColorScheme colorScheme,
  }) {
    return Text(
      title,
      style: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: FrameSize.screenWidth * 0.06,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildServicesContainer({
    required Stream<List<Map<String, dynamic>>> stream,
    required bool Function(Map<String, dynamic>) filter,
    required String emptyMessage,
    required ColorScheme colorScheme,
    required Widget Function(Map<String, dynamic>) buildTrailing,
  }) {
    return Container(
      padding: EdgeInsets.all(FrameSize.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(25),
            spreadRadius: 1,
            blurRadius: FrameSize.screenWidth * 0.02,
            offset: Offset(0, FrameSize.screenHeight * 0.005),
          ),
        ],
      ),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: colorScheme.primary,
                rightDotColor: colorScheme.secondary,
                size: FrameSize.screenWidth * 0.08,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: FrameSize.screenWidth * 0.035),
              ),
            );
          }

          final services = snapshot.data ?? [];
          final filteredServices = services.where(filter).toList();

          if (filteredServices.isEmpty) {
            return Center(
              child: Text(
                emptyMessage,
                style: TextStyle(
                  fontSize: FrameSize.screenWidth * 0.04,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            );
          }

          return Column(
            children: filteredServices.map((value) {
              return _buildServiceListItem(
                  value, buildTrailing(value), colorScheme);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildServiceListItem(
      Map<String, dynamic> value, Widget trailing, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(bottom: FrameSize.screenHeight * 0.015),
      child: Material(
        borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.02),
        elevation: 2,
        child: InkWell(
          onTap: () => _showBookingDetailsBottomSheet(value),
          borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: FrameSize.screenHeight * 0.01,
              horizontal: FrameSize.screenWidth * 0.02,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: FrameSize.screenWidth * 0.03),
                        child: Text(
                          value['patientName'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: FrameSize.screenWidth * 0.045,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: FrameSize.screenHeight * 0.005),
                      Padding(
                        padding:
                            EdgeInsets.only(left: FrameSize.screenWidth * 0.03),
                        child: Text(
                          value['service'] ?? 'Not available',
                          style: TextStyle(
                            fontSize: FrameSize.screenWidth * 0.035,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: FrameSize.screenWidth * 0.3,
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: FrameSize.screenWidth * 0.02),
                    child: trailing,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 300.ms),
    );
  }

  Widget _buildPaymentButton() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: FrameSize.screenWidth * 0.25,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.015),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.015),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: FrameSize.screenWidth * 0.02,
              vertical: FrameSize.screenHeight * 0.005,
            ),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.015),
            ),
            child: Text(
              'Pay Now',
              style: TextStyle(
                fontSize: FrameSize.screenWidth * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(Map<String, dynamic> value) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: FrameSize.screenWidth * 0.25,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.015),
        child: InkWell(
          onTap: () {
            sendOTPEmail(value['book_code'].toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingConfirmationPagetwo(
                  serviceId: value['serviceId'],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(FrameSize.screenWidth * 0.015),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: FrameSize.screenWidth * 0.02,
              vertical: FrameSize.screenHeight * 0.005,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.015),
            ),
            child: Text(
              "Verify Booking",
              style: TextStyle(
                fontSize: FrameSize.screenWidth * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingIndicator() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: FrameSize.screenWidth * 0.25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pending Approval',
            style: TextStyle(
              fontSize: FrameSize.screenWidth * 0.03,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: FrameSize.screenHeight * 0.005),
          LoadingAnimationWidget.flickr(
            leftDotColor: Colors.blueAccent,
            rightDotColor: Colors.pinkAccent,
            size: FrameSize.screenWidth * 0.06,
          ),
        ],
      ),
    );
  }

  void _showBookingDetailsBottomSheet(Map<String, dynamic> value) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Bottomsheet(
          name: value['patientName'],
          service: value['service'],
          startDate: value['startDate'],
          endDate: value['endDate'],
        );
      },
    );
  }
}
