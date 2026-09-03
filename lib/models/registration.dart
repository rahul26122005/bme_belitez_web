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
  final Uint8List? paymentBytes;
  final String paymentContentType;

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
    required this.paymentBytes,
    required this.paymentContentType,
  });

  factory Registration.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final p = (d['payment_screenshot'] as Map?)?.cast<String, dynamic>();
    final raw = p?['image_bytes'];

    Uint8List? bytes;
    if (raw is Uint8List) {
      bytes = raw;
    } else if (raw is List) {
      bytes = Uint8List.fromList(raw.cast<int>());
    }

    DateTime? date;
    final ts = d['registered_at'];
    if (ts is Timestamp) date = ts.toDate();

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
      paymentBytes: bytes,
      paymentContentType: '${p?['content_type'] ?? 'image/jpeg'}',
    );
  }
}
