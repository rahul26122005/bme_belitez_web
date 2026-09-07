import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/registration.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get registrations =>
      db.collection('Registrations');

  /// Creates one registration document.
  ///
  /// The payment screenshot is deliberately stored as Firestore Bytes, not
  /// Firebase Storage.  No timeout and no duplicate-registration check are
  /// used, so every valid submission is allowed to create a new document.
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
    final cleanName = name.trim();
    final cleanCollege = college.trim();
    final cleanDepartment = department.trim();
    final cleanContact = contact.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanTransaction = transactionId.trim();

    if (cleanName.isEmpty ||
        cleanCollege.isEmpty ||
        cleanDepartment.isEmpty ||
        cleanContact.isEmpty ||
        cleanEmail.isEmpty ||
        cleanTransaction.isEmpty) {
      throw FirebaseServiceException(
        'Missing required registration information.',
      );
    }

    if (paymentBytes.isEmpty) {
      throw FirebaseServiceException('Payment screenshot is empty.');
    }

    // Leave substantial room below Firestore's 1 MiB document limit for the
    // other registration fields and Firestore document overhead.
    const maxImageBytes = 800 * 1024;
    if (paymentBytes.lengthInBytes > maxImageBytes) {
      throw FirebaseServiceException(
        'Payment screenshot must be 800 KB or smaller.',
      );
    }

    final safeBytes = Uint8List.fromList(paymentBytes);
    final ref = registrations.doc();
    final registrationId =
        'BEL26-${ref.id.substring(0, 8).toUpperCase()}';

    final data = <String, dynamic>{
      'registration_id': registrationId,
      'name': cleanName,
      'college': cleanCollege,
      'department': cleanDepartment,
      'contact': cleanContact,
      'email': cleanEmail,
      'year': year.trim(),
      'technical_event': technicalEvent.trim().isEmpty
          ? '-'
          : technicalEvent.trim(),
      'nontechnical_event': nonTechnicalEvent.trim().isEmpty
          ? '-'
          : nonTechnicalEvent.trim(),
      'workshop': workshop.trim(),
      'food': food.trim(),
      'transaction_id': cleanTransaction,
      'payment_screenshot': <String, dynamic>{
        'file_name': fileName.trim().isEmpty ? 'payment_screenshot' : fileName.trim(),
        'content_type': contentType.trim().isEmpty
            ? 'application/octet-stream'
            : contentType.trim().toLowerCase(),
        'size_bytes': safeBytes.lengthInBytes,
        'storage_type': 'firestore',
        'image_bytes': safeBytes,
      },
      'status': 'registered',
      'payment_status': 'pending',
      'registered_at': FieldValue.serverTimestamp(),
    };

    try {
      await ref.set(data);
      return registrationId;
    } on FirebaseException catch (e, stackTrace) {
      // Keep the real Firebase error available in the browser console while
      // the registration page shows a safe user-facing message.
      assert(() {
        // ignore: avoid_print
        print('[B-ELITEZ] Firebase code: ${e.code}');
        // ignore: avoid_print
        print('[B-ELITEZ] Firebase message: ${e.message}');
        // ignore: avoid_print
        print('[B-ELITEZ] Firebase plugin: ${e.plugin}');
        // ignore: avoid_print
        print('[B-ELITEZ] Screenshot bytes: ${safeBytes.lengthInBytes}');
        // ignore: avoid_print
        print('[B-ELITEZ] Screenshot type: $contentType');
        // ignore: avoid_print
        print('[B-ELITEZ] Screenshot name: $fileName');
        // ignore: avoid_print
        print(stackTrace);
        return true;
      }());

      throw FirebaseServiceException(
        'Firebase ${e.code}: ${e.message ?? 'The registration could not be saved.'}',
      );
    } catch (e) {
      throw FirebaseServiceException(e.toString());
    }
  }

  Stream<List<Registration>> registrationsStream() {
    return registrations
        .orderBy('registered_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(Registration.fromDoc)
            .toList(growable: false));
  }

  Future<bool> isAdmin() async {
    final user = auth.currentUser;
    if (user == null) return false;

    final doc = await db.collection('admins').doc(user.uid).get();
    return doc.exists && (doc.data()?['active'] ?? true) == true;
  }

  Future<void> updatePaymentStatus(String docId, String value) {
    return registrations.doc(docId).update({
      'payment_status': value.trim().toLowerCase(),
    });
  }

  Future<void> updateRegistrationStatus(String docId, String value) {
    return registrations.doc(docId).update({
      'status': value.trim().toLowerCase(),
    });
  }

  Future<void> deleteRegistration(String docId) {
    return registrations.doc(docId).delete();
  }
}

class FirebaseServiceException implements Exception {
  final String message;
  const FirebaseServiceException(this.message);

  @override
  String toString() => message;
}
