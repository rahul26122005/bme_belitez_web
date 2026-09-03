import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/registration.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get registrations =>
      db.collection('Registrations');

  Future<String> createRegistration({
    required String name,
    required String college,
    required String department,
    required String contact,
    required String email,
    required String year,
    required String technicalEvent,
    required String nonTechnicalEvent,
    required String workshop,
    required String food,
    required String transactionId,
    required Uint8List paymentBytes,
    required String fileName,
    required String contentType,
  }) async {
    if (paymentBytes.isEmpty) throw Exception('Payment screenshot is empty.');
    if (paymentBytes.lengthInBytes > 800 * 1024) {
      throw Exception('Payment screenshot must be 800 KB or smaller.');
    }

    final ref = registrations.doc();
    final registrationId = 'BEL26-${ref.id.substring(0, 8).toUpperCase()}';

    await ref.set({
      'registration_id': registrationId,
      'name': name.trim(),
      'college': college.trim(),
      'department': department.trim(),
      'contact': contact.trim(),
      'email': email.trim().toLowerCase(),
      'year': year,
      'technical_event': technicalEvent,
      'nontechnical_event': nonTechnicalEvent,
      'workshop': workshop,
      'food': food,
      'transaction_id': transactionId.trim(),
      'payment_screenshot': {
        'file_name': fileName,
        'content_type': contentType,
        'size_bytes': paymentBytes.lengthInBytes,
        'storage_type': 'firestore',
        'image_bytes': paymentBytes,
      },
      'status': 'registered',
      'payment_status': 'pending',
      'registered_at': FieldValue.serverTimestamp(),
    });

    return registrationId;
  }

  Stream<List<Registration>> registrationsStream() {
    return registrations
        .orderBy('registered_at', descending: true)
        .snapshots()
        .map((s) => s.docs.map(Registration.fromDoc).toList());
  }

  Future<bool> isAdmin() async {
    final user = auth.currentUser;
    if (user == null) return false;
    final doc = await db.collection('admins').doc(user.uid).get();
    return doc.exists && (doc.data()?['active'] ?? true) == true;
  }

  Future<void> updatePaymentStatus(String docId, String value) =>
      registrations.doc(docId).update({'payment_status': value.toLowerCase()});

  Future<void> updateRegistrationStatus(String docId, String value) =>
      registrations.doc(docId).update({'status': value.toLowerCase()});

  Future<void> deleteRegistration(String docId) =>
      registrations.doc(docId).delete();
}
