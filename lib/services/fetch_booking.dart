import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class FirestoreService {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Map<String, dynamic>>> fetchServices() {
    if (user == null) {
      return Stream.value([]);
    }

    return usersCollection.doc(user!.uid).snapshots().map(
      (snapshot) {
        // debugPrint('Snapshot: $snapshot');
        final data = snapshot.data() as Map<String, dynamic>?; // Get user data
        // debugPrint('Fetching data: $data');
        final services =
            data?['services'] as List<dynamic>?; // Extract services
        // debugPrint('Fetching SERVICES__________: $services');
        return services?.map((e) => Map<String, dynamic>.from(e)).toList() ??
            [];
      },
    );
  }
}
