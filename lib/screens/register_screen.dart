import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../models/event.dart';
import '../services/firebase_service.dart';
import '../utils/theme.dart';
import '../widgets/event_card.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final college = TextEditingController();
  final department = TextEditingController();
  final contact = TextEditingController();
  final email = TextEditingController();
  final transaction = TextEditingController();

  String year = '';
  String technical = '';
  String nonTechnical = '';
  String workshop = '';
  String food = '';

  Uint8List? screenshot;
  String screenshotName = '';
  String screenshotType = 'image/jpeg';

  // Visual-only counter. It NEVER disables submission.
  int submittingCount = 0;

  final technicalEvents =
      events.where((e) => e.category == 'Technical').toList();

  final nonTechnicalEvents =
      events.where((e) => e.category == 'Non-Technical').toList();

  @override
  void dispose() {
    name.dispose();
    college.dispose();
    department.dispose();
    contact.dispose();
    email.dispose();
    transaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: const SiteHeader(showBack: true),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const _Notice(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 35),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          _section(
                            '01',
                            'Participant Details',
                            'All fields are required',
                            _participantSection(),
                          ),
                          const SizedBox(height: 12),
                          _section(
                            '02',
                            'Technical Event *',
                            'Select any one event',
                            _eventGrid(
                              technicalEvents,
                              technical,
                              (event) => setState(
                                () => technical =
                                    technical == event.name ? '' : event.name,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _section(
                            '03',
                            'Non-Technical Event',
                            'Optional',
                            _eventGrid(
                              nonTechnicalEvents,
                              nonTechnical,
                              (event) => setState(
                                () => nonTechnical = nonTechnical == event.name
                                    ? ''
                                    : event.name,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _section(
                            '04',
                            'Workshop & Food',
                            'Complete your preferences',
                            _preferencesSection(),
                          ),
                          const SizedBox(height: 12),
                          _section(
                            '05',
                            'Payment',
                            'Complete payment before submitting',
                            _paymentSection(),
                          ),
                          const SizedBox(height: 12),
                          _submitBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(
    String number,
    String title,
    String hint,
    Widget child,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final compact = constraints.maxWidth < 680;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number • $title',
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (hint.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        hint,
                        softWrap: true,
                        style: const TextStyle(
                          color: AppTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '$number • $title',
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 26,
                          height: 1.12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (hint.isNotEmpty) ...[
                      const SizedBox(width: 15),
                      Flexible(
                        child: Text(
                          hint,
                          textAlign: TextAlign.right,
                          softWrap: true,
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              const SizedBox(height: 17),
              child,
            ],
          );
        },
      ),
    );
  }

  Widget _participantSection() {
    return LayoutBuilder(
      builder: (_, constraints) {
        final twoColumns = constraints.maxWidth >= 680;
        final width =
            twoColumns ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: _field(name, 'Name *', 'Full name'),
            ),
            SizedBox(
              width: width,
              child: _field(
                college,
                'College Name *',
                'College / Institution',
              ),
            ),
            SizedBox(
              width: width,
              child: _field(
                department,
                'Department *',
                'Department',
              ),
            ),
            SizedBox(
              width: width,
              child: _field(
                contact,
                'Contact Number *',
                '10-digit mobile number',
                phone: true,
              ),
            ),
            SizedBox(
              width: width,
              child: _field(
                email,
                'Mail ID *',
                'you@example.com',
                email: true,
              ),
            ),
            SizedBox(
              width: width,
              child: _choice(
                'Year *',
                const [
                  '1st YEAR',
                  '2nd YEAR',
                  '3rd YEAR',
                  'FINAL YEAR',
                ],
                year,
                (value) => setState(() => year = value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String hint, {
    bool phone = false,
    bool email = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 1,
      keyboardType: email
          ? TextInputType.emailAddress
          : phone
              ? TextInputType.phone
              : TextInputType.text,
      textCapitalization:
          email ? TextCapitalization.none : TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 15,
        ),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (text.isEmpty) return 'Required';

        if (phone && !RegExp(r'^[0-9]{10}$').hasMatch(text)) {
          return 'Enter a valid 10-digit number';
        }

        if (email && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
          return 'Enter a valid email';
        }

        return null;
      },
    );
  }

  Widget _choice(
    String label,
    List<String> values,
    String value,
    ValueChanged<String> onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          softWrap: true,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: values.map((item) {
            final selected = item == value;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onChange(item),
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFEAFBFA) : Colors.white,
                    border: Border.all(
                      color: selected ? AppTheme.teal : AppTheme.border,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 18,
                        color: selected ? AppTheme.teal : Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          item,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _eventGrid(
    List<Event> list,
    String selected,
    ValueChanged<Event> onSelect,
  ) {
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'No events are currently available.',
          softWrap: true,
          style: TextStyle(color: AppTheme.muted),
        ),
      );
    }

    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 820 ? 2 : 1;
        const gap = 10.0;

        final cardWidth = columns == 1 ? width : (width - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: list.map((event) {
            return SizedBox(
              width: cardWidth,
              child: EventCard(
                event: event,
                selectable: true,
                selected: selected == event.name,
                onTap: () => onSelect(event),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _preferencesSection() {
    return LayoutBuilder(
      builder: (_, constraints) {
        final two = constraints.maxWidth >= 620;
        final width =
            two ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 14,
          children: [
            SizedBox(
              width: width,
              child: _choice(
                'Workshop *',
                const ['YES', 'NO'],
                workshop,
                (value) => setState(() => workshop = value),
              ),
            ),
            SizedBox(
              width: width,
              child: _choice(
                'Food *',
                const ['VEG', 'NON-VEG'],
                food,
                (value) => setState(() => food = value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _paymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Pay using any one of the QR codes below. '
            'After payment, enter the transaction ID and upload '
            'your payment screenshot.',
            softWrap: true,
            style: TextStyle(
              color: AppTheme.muted,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 13),
        _qrSection(),
        const SizedBox(height: 14),
        _field(
          transaction,
          'TRANSACTION ID *',
          'Enter your UPI transaction ID',
        ),
        const SizedBox(height: 5),
        const Text(
          'Enter the transaction/reference ID shown in your '
          'payment application.',
          softWrap: true,
          style: TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Upload payment screenshot *',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'JPG, JPEG, PNG, WEBP. Maximum 10 MB',
          softWrap: true,
          style: TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _pick,
            icon: const Icon(Icons.upload_file),
            label: Text(
              screenshot == null
                  ? 'Choose Payment Screenshot'
                  : 'Change Screenshot',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (screenshot != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 240),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppTheme.lightBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Image.memory(
              screenshot!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Unable to preview this image.',
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _qrSection() {
    return LayoutBuilder(
      builder: (_, constraints) {
        final two = constraints.maxWidth >= 680;
        final width =
            two ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _qr(width, 'Payment QR – 1', 'assets/images/payment_qr_1.jpeg'),
            _qr(width, 'Payment QR – 2', 'assets/images/payment_qr_2.jpeg'),
          ],
        );
      },
    );
  }

  Widget _qr(double width, String title, String asset) {
    final qrHeight = width < 330
        ? 210.0
        : width < 450
            ? 250.0
            : width < 700
                ? 280.0
                : 310.0;

    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(13),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: qrHeight,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5FB),
                borderRadius: BorderRadius.circular(9),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Payment QR image not found.',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          color: AppTheme.muted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitBar() {
    final processing = submittingCount > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.dark,
        borderRadius: BorderRadius.circular(17),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final width = constraints.maxWidth;

          // Mobile / narrow tablet
          if (width < 650) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'READY?',
                  style: TextStyle(
                    color: AppTheme.teal,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Submit your B’ELITEZ 2K26 registration.',
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'IMPORTANT: Your registration is successful ONLY '
                  'when the Registration Successful message appears. '
                  'Please verify your registration by contacting '
                  '7448665022.',
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.teal,
                      foregroundColor: AppTheme.dark,
                      minimumSize: const Size.fromHeight(48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: processing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.dark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Submit Again ($submittingCount)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Submit Registration →',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
              ],
            );
          }

          // Desktop / large tablet
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'READY?',
                        style: TextStyle(
                          color: AppTheme.teal,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Submit your B’ELITEZ 2K26 registration.',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'IMPORTANT: Your registration is successful ONLY '
                        'when the Registration Successful message appears. '
                        'Please verify your registration by contacting '
                        '7448665022.',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 0,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.teal,
                    foregroundColor: AppTheme.dark,
                    minimumSize: const Size(190, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: processing
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.dark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Submit Again ($submittingCount)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'Submit Registration →',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pick() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        if (mounted) {
          await _showErrorDialog(
            title: 'Empty Image',
            message: 'The selected image contains no data.',
            details: 'Please choose another payment screenshot.',
            code: 'IMG-000',
          );
        }
        return;
      }

      if (bytes.lengthInBytes > 10 * 1024 * 1024) {
        if (mounted) {
          await _showErrorDialog(
            title: 'Image Too Large',
            message: 'The selected payment screenshot is larger than 10 MB.',
            details: 'Please select a smaller JPG, JPEG, PNG or WEBP image (maximum 10 MB).',
            code: 'IMG-001',
          );
        }
        return;
      }

      // Firestore has a 1 MiB document limit. Compress the screenshot
      // before it is ever sent to Firestore. The compressor keeps the
      // image readable while targeting a much smaller file size.
      final compressed = await _compressPaymentScreenshot(bytes);

      if (compressed == null || compressed.isEmpty) {
        if (mounted) {
          await _showErrorDialog(
            title: 'Image Compression Failed',
            message: 'The payment screenshot could not be prepared.',
            details: 'Please choose another JPG, JPEG, PNG or WEBP image and try again.',
            code: 'IMG-004',
          );
        }
        return;
      }

      if (!mounted) return;

      setState(() {
        screenshot = compressed;
        // Compression converts the uploaded image to JPEG.
        screenshotName = 'payment_screenshot.jpg';
        screenshotType = 'image/jpeg';
      });
    } catch (e, stack) {
      _logError('Image selection error', e, stack);

      if (mounted) {
        await _showErrorDialog(
          title: 'Unable to Select Image',
          message: 'The payment screenshot could not be selected.',
          details: 'Please try again. If the problem continues, '
              'contact 7448665022.',
          code: 'IMG-003',
        );
      }
    }
  }

  Future<Uint8List?> _compressPaymentScreenshot(Uint8List original) async {
    try {
      final decoded = img.decodeImage(original);
      if (decoded == null) return null;

      // Keep enough resolution for transaction details and text to remain
      // readable on the admin dashboard, but remove unnecessary camera
      // resolution.
      const maxDimension = 1600;
      img.Image working = decoded;

      final largest = working.width > working.height
          ? working.width
          : working.height;

      if (largest > maxDimension) {
        final scale = maxDimension / largest;
        working = img.copyResize(
          working,
          width: (working.width * scale).round(),
          height: (working.height * scale).round(),
          interpolation: img.Interpolation.average,
        );
      }

      // Try progressively stronger JPEG compression. The first successful
      // result under 650 KB is used. Keeping this below 1 MiB leaves room
      // for the other Firestore fields in the Registration document.
      const targetBytes = 650 * 1024;
      const qualities = <int>[82, 74, 66, 58, 50];

      for (final quality in qualities) {
        final encoded = img.encodeJpg(working, quality: quality);
        if (encoded.length <= targetBytes) {
          return Uint8List.fromList(encoded);
        }
      }

      // If the image is still larger than the target, reduce the dimensions
      // and try once more. This is still preferable to storing a multi-MB
      // original screenshot in Firestore.
      for (final dimension in <int>[1400, 1200, 1000]) {
        final largestNow = working.width > working.height
            ? working.width
            : working.height;
        if (largestNow > dimension) {
          final scale = dimension / largestNow;
          working = img.copyResize(
            working,
            width: (working.width * scale).round(),
            height: (working.height * scale).round(),
            interpolation: img.Interpolation.average,
          );
        }

        final encoded = img.encodeJpg(working, quality: 55);
        if (encoded.length <= targetBytes) {
          return Uint8List.fromList(encoded);
        }
      }

      // Last resort: return the most compressed version. The Firebase
      // service will chunk it if it is still above the safe single-document
      // threshold.
      final finalBytes = img.encodeJpg(working, quality: 45);
      return Uint8List.fromList(finalBytes);
    } catch (e, stack) {
      _logError('Image compression error', e, stack);
      return null;
    }
  }

  String _mime(String filename) {
    final value = filename.toLowerCase();

    if (value.endsWith('.jpg') || value.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    if (value.endsWith('.png')) {
      return 'image/png';
    }

    if (value.endsWith('.webp')) {
      return 'image/webp';
    }

    return 'image/jpeg';
  }

  Future<void> _submit() async {
    try {
      if (!formKey.currentState!.validate()) {
        await _showValidationDialog(
          title: 'Check Your Details',
          message: 'Some participant details are missing or invalid.',
          details: 'Please correct the highlighted fields and submit again.',
          code: 'FORM-001',
        );
        return;
      }

      if (year.isEmpty) {
        await _showValidationDialog(
          title: 'Year Required',
          message: 'Please select your year.',
          details: 'Choose 1st YEAR, 2nd YEAR, 3rd YEAR or FINAL YEAR.',
          code: 'FORM-002',
        );
        return;
      }

      if (technical.isEmpty && nonTechnical.isEmpty) {
        await _showValidationDialog(
          title: 'Event Selection Required',
          message: 'Please select at least one event.',
          details: 'Choose a Technical event or a Non-Technical event.',
          code: 'FORM-003',
        );
        return;
      }

      if (workshop.isEmpty) {
        await _showValidationDialog(
          title: 'Workshop Selection Required',
          message: 'Please select YES or NO for Workshop.',
          details: 'Complete the Workshop selection before submitting.',
          code: 'FORM-004',
        );
        return;
      }

      if (food.isEmpty) {
        await _showValidationDialog(
          title: 'Food Selection Required',
          message: 'Please select VEG or NON-VEG.',
          details: 'Complete the Food selection before submitting.',
          code: 'FORM-005',
        );
        return;
      }

      if (transaction.text.trim().isEmpty) {
        await _showValidationDialog(
          title: 'Transaction ID Required',
          message: 'Please enter your payment transaction ID.',
          details: 'Enter the transaction/reference ID shown in your '
              'payment application.',
          code: 'PAY-001',
        );
        return;
      }

      if (screenshot == null) {
        await _showValidationDialog(
          title: 'Payment Screenshot Required',
          message: 'Please upload your payment screenshot.',
          details: 'A payment screenshot is required before registration.',
          code: 'PAY-002',
        );
        return;
      }

      if (mounted) {
        setState(() => submittingCount++);
      }

      try {
        // NO timeout.
        // NO duplicate check.
        // NO "already submitting" guard.
        final id = await FirebaseService.instance.createRegistration(
          name: name.text.trim(),
          college: college.text.trim(),
          department: department.text.trim(),
          contact: contact.text.trim(),
          email: email.text.trim(),
          year: year,
          technicalEvent: technical.isEmpty ? '-' : technical,
          nonTechnicalEvent: nonTechnical.isEmpty ? '-' : nonTechnical,
          workshop: workshop,
          food: food,
          transactionId: transaction.text.trim(),
          paymentBytes: screenshot!,
          fileName: screenshotName,
          contentType: screenshotType,
        );

        if (!mounted) return;

        await _showSuccessDialog(id);
      } catch (e, stack) {
        _logError('Registration submission error', e, stack);

        if (mounted) {
          final info = _firebaseErrorInfo(e);

          await _showErrorDialog(
            title: info.title,
            message: info.message,
            details: info.details,
            code: info.code,
          );
        }
      } finally {
        if (mounted && submittingCount > 0) {
          setState(() => submittingCount--);
        }
      }
    } catch (e, stack) {
      _logError('Unexpected registration error', e, stack);

      if (mounted) {
        await _showErrorDialog(
          title: 'Unexpected Error',
          message: 'Something unexpected happened while processing '
              'your registration.',
          details: 'Please try again. If the problem continues, '
              'contact 7448665022.',
          code: 'REG-999',
        );
      }
    }
  }

  Future<void> _showSuccessDialog(String id) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50,
        ),
        title: const Text(
          'Registration Successful',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your registration has been submitted successfully.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FA),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  'Registration ID\n$id',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Payment status: PENDING.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'IMPORTANT\n'
                'Your registration is successful ONLY when this '
                'success message appears.\n\n'
                'Please verify your registration by contacting '
                '7448665022.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/register-home',
                (_) => false,
              );
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _showValidationDialog({
    required String title,
    required String message,
    required String details,
    required String code,
  }) {
    return _showErrorDialog(
      title: title,
      message: message,
      details: details,
      code: code,
      warning: true,
    );
  }

  Future<void> _showErrorDialog({
    required String title,
    required String message,
    required String details,
    required String code,
    bool warning = false,
  }) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: Icon(
          warning ? Icons.warning_amber_rounded : Icons.error_outline,
          color: warning ? Colors.orange : Colors.red,
          size: 50,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                details,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 13),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Text(
                  'Need help?\nContact: 7448665022',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Error Code: $code',
                style: const TextStyle(
                  color: AppTheme.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _FirebaseErrorInfo _firebaseErrorInfo(Object error) {
    final raw = error.toString().toLowerCase();

    if (raw.contains('permission-denied')) {
      return const _FirebaseErrorInfo(
        title: 'Permission Denied',
        message: 'The registration could not be saved because '
            'permission was denied.',
        details: 'Please try again. If this continues, contact 7448665022.',
        code: 'FB-001',
      );
    }

    if (raw.contains('unavailable') ||
        raw.contains('network') ||
        raw.contains('internet')) {
      return const _FirebaseErrorInfo(
        title: 'Connection Problem',
        message: 'The registration could not be completed because '
            'the internet connection or Firebase service is '
            'temporarily unavailable.',
        details: 'Check your internet connection and try again. '
            'If the problem continues, contact 7448665022.',
        code: 'NET-001',
      );
    }

    if (raw.contains('deadline-exceeded')) {
      return const _FirebaseErrorInfo(
        title: 'Server Response Delayed',
        message: 'The server has not responded yet.',
        details: 'There is no 45-second timeout in this page. '
            'Please verify with 7448665022 before submitting '
            'again if you are unsure whether it was saved.',
        code: 'FB-002',
      );
    }

    if (raw.contains('resource-exhausted')) {
      return const _FirebaseErrorInfo(
        title: 'Service Limit Reached',
        message: 'The registration service has reached a temporary '
            'usage limit.',
        details: 'Please try again later or contact 7448665022.',
        code: 'FB-003',
      );
    }

    if (raw.contains('failed-precondition')) {
      return const _FirebaseErrorInfo(
        title: 'Service Configuration Error',
        message: 'The registration service is not ready to process '
            'this request.',
        details: 'Please contact 7448665022 so the registration '
            'system can be checked.',
        code: 'FB-004',
      );
    }

    if (raw.contains('invalid-argument')) {
      return const _FirebaseErrorInfo(
        title: 'Invalid Registration Data',
        message: 'Some registration information could not be accepted.',
        details: 'Please check your entered details and try again. '
            'If the problem continues, contact 7448665022.',
        code: 'FB-005',
      );
    }

    if (raw.contains('unauthenticated')) {
      return const _FirebaseErrorInfo(
        title: 'Authentication Error',
        message: 'The registration service could not authenticate '
            'the request.',
        details: 'Please try again. If the problem continues, '
            'contact 7448665022.',
        code: 'FB-006',
      );
    }

    return const _FirebaseErrorInfo(
      title: 'Registration Failed',
      message: 'We could not complete your registration.',
      details: 'Please try again. If the problem continues, '
          'contact 7448665022.',
      code: 'REG-008',
    );
  }

  void _logError(
    String message,
    Object error,
    StackTrace stack,
  ) {
    debugPrint('[B-ELITEZ] $message');
    debugPrint('[B-ELITEZ] $error');
    debugPrintStack(stackTrace: stack);
  }
}

class _FirebaseErrorInfo {
  final String title;
  final String message;
  final String details;
  final String code;

  const _FirebaseErrorInfo({
    required this.title,
    required this.message,
    required this.details,
    required this.code,
  });
}

class _Notice extends StatelessWidget {
  const _Notice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      color: const Color(0xFFFFF8F0),
      child: const Center(
        child: Column(
          children: [
            Text(
              '📌 Important: Accommodation will not be provided.',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 11.5,
                height: 1.35,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Registration is successful ONLY when the '
              'Registration Successful message appears. '
              'Please verify your registration by contacting '
              '7448665022.',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.red,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
