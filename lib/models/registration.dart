import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration {
  final String docId;
  final String registrationId;
  final String name;
  final String college;
  final String department;
  final String contact;
  final String email;
  final String year;
  final String technicalEvent;
  final String nonTechnicalEvent;
  final String workshop;
  final String food;
  final String transactionId;
  final String paymentStatus;
  final String status;
  final DateTime? registeredAt;

  // New Firestore-only chunked screenshot metadata.
  final bool hasPaymentScreenshot;
  final String paymentFileName;
  final String paymentContentType;
  final int paymentSizeBytes;

  // Backward compatibility with old documents that stored image_bytes directly.
  final Uint8List? paymentBytes;

  const Registration({
    required this.docId,
    required this.registrationId,
    required this.name,
    required this.college,
    required this.department,
    required this.contact,
    required this.email,
    required this.year,
    required this.technicalEvent,
    required this.nonTechnicalEvent,
    required this.workshop,
    required this.food,
    required this.transactionId,
    required this.paymentStatus,
    required this.status,
    required this.registeredAt,
    required this.hasPaymentScreenshot,
    required this.paymentFileName,
    required this.paymentContentType,
    required this.paymentSizeBytes,
    required this.paymentBytes,
  });

  factory Registration.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final p = (d['payment_screenshot'] as Map?)?.cast<String, dynamic>();
    // Older versions stored image_bytes inside payment_screenshot.
    // New compressed screenshots are stored as payment_screenshot_bytes
    // directly on the Registration document.
    final raw = p?['image_bytes'];
    final directRaw = d['payment_screenshot_bytes'];

    Uint8List? legacyBytes;
    if (directRaw is Uint8List) {
      legacyBytes = directRaw;
    } else if (directRaw is List) {
      legacyBytes = Uint8List.fromList(directRaw.cast<int>());
    } else if (raw is Uint8List) {
      legacyBytes = raw;
    } else if (raw is List) {
      legacyBytes = Uint8List.fromList(raw.cast<int>());
    }

    DateTime? date;
    final ts = d['registered_at'];
    if (ts is Timestamp) date = ts.toDate();

    final metadataSize = p?['size_bytes'];
    final size = metadataSize is int
        ? metadataSize
        : metadataSize is num
            ? metadataSize.toInt()
            : legacyBytes?.lengthInBytes ?? 0;

    final hasImage = legacyBytes != null ||
        p != null &&
            ((p['total_chunks'] is num && (p['total_chunks'] as num) > 0) ||
                p['storage_type'] == 'firestore_chunks');

    return Registration(
      docId: doc.id,
      registrationId: '${d['registration_id'] ?? doc.id}',
      name: '${d['name'] ?? ''}',
      college: '${d['college'] ?? ''}',
      department: '${d['department'] ?? ''}',
      contact: '${d['contact'] ?? ''}',
      email: '${d['email'] ?? ''}',
      year: '${d['year'] ?? ''}',
      technicalEvent: '${d['technical_event'] ?? '-'}',
      nonTechnicalEvent: '${d['nontechnical_event'] ?? '-'}',
      workshop: '${d['workshop'] ?? ''}',
      food: '${d['food'] ?? ''}',
      transactionId: '${d['transaction_id'] ?? ''}',
      paymentStatus: '${d['payment_status'] ?? 'pending'}'.toUpperCase(),
      status: '${d['status'] ?? 'registered'}'.toUpperCase(),
      registeredAt: date,
      hasPaymentScreenshot: hasImage,
      paymentFileName: '${p?['file_name'] ?? 'payment_screenshot'}',
      paymentContentType: '${p?['content_type'] ?? 'image/jpeg'}',
      paymentSizeBytes: size,
      paymentBytes: legacyBytes,
    );
  }
}
