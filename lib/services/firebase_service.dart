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

  /// Firestore has a 1 MiB limit PER DOCUMENT.
  ///
  /// Payment screenshots are therefore stored only in Firestore. Compressed
  /// screenshots normally fit directly in the Registration document; an
  /// oversized compressed image is split into small documents under:
  /// Registrations/{registrationDocId}/payment_chunks/{chunkId}
  ///
  /// This avoids the old error where a 2.2 MB screenshot was being written
  /// into one Registration document.
  // Target for compressed screenshots. The registration document contains
  // all normal fields as well, so keep the image comfortably below 1 MiB.
  static const int _singleDocumentImageLimit = 650 * 1024;
  static const int _chunkSize = 450 * 1024;
  static const int _maxScreenshotBytes = 10 * 1024 * 1024;

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
      throw const FirebaseServiceException(
        'Missing required registration information.',
      );
    }

    if (paymentBytes.isEmpty) {
      throw const FirebaseServiceException('Payment screenshot is empty.');
    }

    if (paymentBytes.lengthInBytes > _maxScreenshotBytes) {
      throw const FirebaseServiceException(
        'Payment screenshot must be 10 MB or smaller.',
      );
    }

    final safeBytes = Uint8List.fromList(paymentBytes);
    final ref = registrations.doc();
    final registrationId = 'BEL26-${ref.id.substring(0, 8).toUpperCase()}';

    // Compression happens in RegisterScreen before this method is called.
    // Store a compressed image directly in the registration document when
    // it is small enough. This is much cheaper than creating chunk documents.
    // Chunking remains only as a safety fallback for unusually large images.
    final storeDirectly = safeBytes.lengthInBytes <= _singleDocumentImageLimit;
    final totalChunks = storeDirectly
        ? 0
        : (safeBytes.lengthInBytes + _chunkSize - 1) ~/ _chunkSize;

    final batch = db.batch();

    batch.set(ref, <String, dynamic>{
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
        'file_name': fileName.trim().isEmpty
            ? 'payment_screenshot'
            : fileName.trim(),
        'content_type': contentType.trim().isEmpty
            ? 'application/octet-stream'
            : contentType.trim().toLowerCase(),
        'size_bytes': safeBytes.lengthInBytes,
        'storage_type': storeDirectly ? 'firestore_document' : 'firestore_chunks',
        'compressed': true,
        'chunk_size_bytes': storeDirectly ? 0 : _chunkSize,
        'total_chunks': totalChunks,
      },
      // Direct Firestore binary field. It is intentionally omitted when the
      // image needs the chunk fallback.
      if (storeDirectly) 'payment_screenshot_bytes': safeBytes,
      'status': 'registered',
      'payment_status': 'pending',
      'registered_at': FieldValue.serverTimestamp(),
    });

    if (!storeDirectly) {
      for (var index = 0; index < totalChunks; index++) {
        final start = index * _chunkSize;
        final end = (start + _chunkSize > safeBytes.lengthInBytes)
            ? safeBytes.lengthInBytes
            : start + _chunkSize;
        final chunk = Uint8List.fromList(safeBytes.sublist(start, end));

        final chunkRef = ref.collection('payment_chunks').doc(
          index.toString().padLeft(6, '0'),
        );

        batch.set(chunkRef, <String, dynamic>{
          'chunk_index': index,
          'total_chunks': totalChunks,
          'bytes': chunk,
        });
      }
    }

    try {
      await batch.commit();
      return registrationId;
    } on FirebaseException catch (e, stackTrace) {
      assert(() {
        // ignore: avoid_print
        print('[B-ELITEZ] Firebase code: ${e.code}');
        // ignore: avoid_print
        print('[B-ELITEZ] Firebase message: ${e.message}');
        // ignore: avoid_print
        print('[B-ELITEZ] Screenshot bytes: ${safeBytes.lengthInBytes}');
        // ignore: avoid_print
        print('[B-ELITEZ] Screenshot chunks: $totalChunks');
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
        .map(
          (snapshot) => snapshot.docs
              .map(Registration.fromDoc)
              .toList(growable: false),
        );
  }

  /// Loads a screenshot from Firestore only.
  ///
  /// New registrations are assembled from payment_chunks. Older documents
  /// that used the previous embedded image_bytes format are also supported.
  Future<Uint8List?> getPaymentScreenshot(Registration registration) async {
    if (registration.paymentBytes != null) {
      return registration.paymentBytes;
    }

    if (!registration.hasPaymentScreenshot) return null;

    // New compressed screenshots normally live directly in the Registration
    // document, avoiding extra Firestore documents and reads.
    final registrationDoc = await registrations.doc(registration.docId).get();
    final registrationData = registrationDoc.data();
    final direct = registrationData?['payment_screenshot_bytes'];
    if (direct is Uint8List) return direct;
    if (direct is List) return Uint8List.fromList(direct.cast<int>());

    final snapshot = await registrations
        .doc(registration.docId)
        .collection('payment_chunks')
        .orderBy('chunk_index')
        .get();

    if (snapshot.docs.isEmpty) return null;

    final chunks = <int, Uint8List>{};

    for (final doc in snapshot.docs) {
      final raw = doc.data()['bytes'];
      if (raw is Uint8List) {
        chunks[doc.data()['chunk_index'] as int] = raw;
      } else if (raw is List) {
        chunks[doc.data()['chunk_index'] as int] =
            Uint8List.fromList(raw.cast<int>());
      }
    }

    if (chunks.isEmpty) return null;

    final ordered = chunks.keys.toList()..sort();
    final output = BytesBuilder(copy: false);
    for (final index in ordered) {
      final chunk = chunks[index];
      if (chunk != null) output.add(chunk);
    }

    return output.takeBytes();
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

  /// Deletes the registration and all Firestore screenshot chunks.
  Future<void> deleteRegistration(String docId) async {
    final registrationRef = registrations.doc(docId);
    final chunks = await registrationRef.collection('payment_chunks').get();

    // Delete chunk documents first. A screenshot is normally only a handful
    // of chunks, but process in batches so the 500-write Firestore limit is
    // never exceeded.
    WriteBatch batch = db.batch();
    var operations = 0;

    for (final chunk in chunks.docs) {
      batch.delete(chunk.reference);
      operations++;
      if (operations == 450) {
        await batch.commit();
        batch = db.batch();
        operations = 0;
      }
    }

    if (operations > 0) {
      await batch.commit();
    }

    await registrationRef.delete();
  }
}

class FirebaseServiceException implements Exception {
  final String message;
  const FirebaseServiceException(this.message);

  @override
  String toString() => message;
}
