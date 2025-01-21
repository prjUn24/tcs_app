import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Function to create a booking
  Future<void> createBooking(Map<String, dynamic> bookingDetails) async {
    try {
      // Generate a unique service ID
      String serviceId = _firestore.collection('bookings').doc().id;
      final emailDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      // Generate a 6-digit OTP
      String otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
          .toString();

      // Add booking details to Firestore
      await _firestore.collection('bookings').doc(serviceId).set({
        ...bookingDetails,
        'serviceId': serviceId,
        'otp': otp,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Sending Email to the address');
      // // Send OTP to user's email
      sendOTPEmail(emailDoc.data()?['email'], otp);

      Fluttertoast.showToast(
        msg: "Booking created and OTP sent to email!",
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error creating booking: $error",
      );
    }
  }

  /// Function to send OTP email
  void sendOTPEmail(String email, String otp) async {
    try {
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
      Fluttertoast.showToast(msg: "Failed to send OTP: $error");
    }
  }

  /// Function to confirm booking
  Future<void> confirmBooking(String serviceId, String enteredOtp) async {
    try {
      // Get booking details from Firestore
      DocumentSnapshot bookingSnapshot =
          await _firestore.collection('bookings').doc(serviceId).get();

      if (!bookingSnapshot.exists) {
        Fluttertoast.showToast(msg: "Invalid Service ID");
        return;
      }

      var bookingData = bookingSnapshot.data() as Map<String, dynamic>;

      // Validate OTP
      if (bookingData['otp'] != enteredOtp) {
        Fluttertoast.showToast(msg: "Invalid OTP");
        return;
      }

      // Move booking to confirmedBookings collection
      await _firestore.collection('confirmedBookings').doc(serviceId).set({
        ...bookingData,
        'status': 'Confirmed',
        'confirmedAt': FieldValue.serverTimestamp(),
      });

      // Delete the original booking entry
      await _firestore.collection('bookings').doc(serviceId).delete();

      Fluttertoast.showToast(msg: "Booking confirmed successfully!");
    } catch (error) {
      Fluttertoast.showToast(msg: "Error confirming booking: $error");
    }
  }
}
