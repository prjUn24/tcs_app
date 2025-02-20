import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  /// Function to create a booking
  Future<void> createBooking(Map<String, dynamic> bookingDetails) async {
    try {
      // Generate a unique service ID
      String serviceId = _firestore.collection('services').doc().id;

      // Generate a 6-digit OTP
      String otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
          .toString();

      // Add booking details to Firestore
      await _firestore.collection('services').doc(serviceId).set({
        ...bookingDetails,
        'serviceId': serviceId,
        'book_code': otp,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      updateUserServicesArray(
        bookingDetails['patientName'],
        bookingDetails['service'],
        bookingDetails['condition'],
        userId,
        bookingDetails['endDate'],
        bookingDetails['startDate'],
        otp,
        serviceId,
      );

      print('Sending Email to the address');

      // // Send OTP to user's email

      final emailDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
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

  Future<void> updateUserServicesArray(
      String name,
      String service,
      String consultation,
      String userId,
      String endDate,
      String startDate,
      String otp,
      String serviceId) async {
    try {
      // Reference to the user's document
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Update the user's services array with new data
      await userDocRef.update({
        'services': FieldValue.arrayUnion([
          {
            'patientName': name,
            'service': service,
            'startDate': startDate,
            'consultation': consultation,
            'endDate': endDate,
            'book_code': otp,
            'serviceId': serviceId,
            'status': 'pending',
            // 'admin_status': 'pending',
          }
        ]),
      });

      print("User services array updated successfully");
    } catch (err) {
      print("Error updating user services array: $err");

      // Clean up the temporary service if the user update fails
      DocumentReference bookingsDocRef =
          FirebaseFirestore.instance.collection('service').doc(serviceId);
      await bookingsDocRef.delete();

      throw Exception("Failed to update user services array");
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

  Future<void> confirmBooking(String serviceId, String enteredOtp) async {
    try {
      // Fetch user data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      // Get services array from user data
      final List<dynamic>? services = userDoc.data()?['services'];

      if (services == null || services.isEmpty) {
        Fluttertoast.showToast(msg: "No services found for the user.");
        return;
      }

      // Find the correct service by serviceId
      final service = services.firstWhere(
        (service) => service['serviceId'] == serviceId,
        orElse: () => null,
      );

      if (service == null) {
        Fluttertoast.showToast(msg: "Service not found.");
        return;
      }

      // Validate OTP
      if (service['book_code'] != enteredOtp) {
        Fluttertoast.showToast(msg: "Invalid OTP.");
        return;
      }

      // Update the status to 'Confirmed' in the user's services array
      final updatedServices = services.map((item) {
        if (item['serviceId'] == serviceId) {
          return {
            ...item,
            'status': 'confirmed',
          };
        }
        return item;
      }).toList();

      // Update the user's document with the updated services array
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'services': updatedServices});

      // Update the status in the bookings collection
      await FirebaseFirestore.instance
          .collection('service')
          .doc(serviceId)
          .update({'status': 'confirmed'});

      // Success message
      Fluttertoast.showToast(msg: "Booking confirmed successfully!");
    } catch (error) {
      // Handle errors
      Fluttertoast.showToast(msg: "Error confirming booking: $error");
    }
  }
}
