// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Map<String, String> lastBookingStatus =
      {}; // Stores last known booking status

  PushNotificationService() {
    setupLocalNotifications();
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted.");
    } else {
      print("❌ Notification permission denied.");
    }
  }

  // void setupBookingListener() {
  //   FirebaseFirestore.instance
  //       .collection("services")
  //       .snapshots()
  //       .listen((QuerySnapshot snapshot) {
  //     for (var doc in snapshot.docs) {
  //       String bookingId = doc.id;
  //       String newStatus = doc["status"];

  //       // Check if status has changed before sending notification
  //       if (lastBookingStatus[bookingId] != newStatus) {
  //         lastBookingStatus[bookingId] = newStatus; // Update stored status

  //         String message = _getNotificationMessage(newStatus);
  //         if (message.isNotEmpty) {
  //           showNotification(message);
  //         }
  //       }
  //     }
  //   });
  // }

  void setupBookingListener(String userId) {
  FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .snapshots()
      .listen((DocumentSnapshot userDoc) {
    if (!userDoc.exists || userDoc.data() == null) return;

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    if (userData.containsKey("services")) {
      List<dynamic> services = userData["services"]; // Extract services array

      for (var service in services) {
        if (service is Map<String, dynamic> && service.containsKey("status")) {
          String serviceId = service["serviceId"]; // Use `serviceId` for tracking
          String newStatus = service["status"];

          // Check if status has changed before sending notification
          if (lastBookingStatus[serviceId] != newStatus) {
            lastBookingStatus[serviceId] = newStatus; // Update stored status

            String message = _getNotificationMessage(newStatus);
            if (message.isNotEmpty) {
              showNotification(message);
            }
          }
        }
      }
    }
  });
}


  String _getNotificationMessage(String status) {
    switch (status) {
      case "pending":
        return "You have a pending booking to be confirmed.";
      case "confirmed":
        return "Your booking is confirmed, waiting for the admin to assign a nurse.";
      case "assigned":
        return "Your nurse is assigned.";
      default:
        return "";
    }
  }

  void setupLocalNotifications() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String message) async {
    var androidDetails = const AndroidNotificationDetails(
      "the_caring_souls_channel",
      "The Caring Souls Booking Notifications",
      importance: Importance.high,
      priority: Priority.high,
    );

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      "Booking Status Update",
      message,
      generalNotificationDetails,
    );
  }
}
