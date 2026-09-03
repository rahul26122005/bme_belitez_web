import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  bool loading = false;

  final technicalEvents = events.where((e) => e.category == 'Technical').toList();
  final nonTechnicalEvents = events.where((e) => e.category == 'Non-Technical').toList();

  @override
  void dispose() {
    for (final c in [name, college, department, contact, email, transaction]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(showBack: true),
      body: SingleChildScrollView(
        child: Column(children: [
          const _Notice(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 45),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1160),
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    _section('01', 'Participant Details', 'All fields are required',
                      LayoutBuilder(builder: (_, c) {
                        final two = c.maxWidth >= 760;
                        final width = two ? (c.maxWidth - 18) / 2 : c.maxWidth;
                        return Wrap(
                          spacing: 18, runSpacing: 15,
                          children: [
                            SizedBox(width: width, child: _field(name, 'Name *', 'Full name')),
                            SizedBox(width: width, child: _field(college, 'College Name *', 'College / Institution')),
                            SizedBox(width: width, child: _field(department, 'Department *', 'Department')),
                            SizedBox(width: width, child: _field(contact, 'Contact Number *', '10-digit mobile number', phone: true)),
                            SizedBox(width: width, child: _field(email, 'Mail ID *', 'you@example.com', email: true)),
                            SizedBox(width: width, child: _choice('Year *', ['1st YEAR','2nd YEAR','3rd YEAR','FINAL YEAR'], year, (v) => setState(() => year = v))),
                          ],
                        );
                      })),
                    const SizedBox(height: 18),
                    _section('02', 'Technical Event *', 'Select any one event',
                      _eventGrid(technicalEvents, technical, (e) => setState(() => technical = technical == e.name ? '' : e.name))),
                    const SizedBox(height: 18),
                    _section('03', 'Non-Technical Event','',
                      _eventGrid(nonTechnicalEvents, nonTechnical, (e) => setState(() => nonTechnical = nonTechnical == e.name ? '' : e.name))),
                    const SizedBox(height: 18),
                    _section('04', 'Workshop & Food', 'Complete your preferences',
                      LayoutBuilder(builder: (_, c) {
                        final two = c.maxWidth >= 700;
                        final width = two ? (c.maxWidth - 18) / 2 : c.maxWidth;
                        return Wrap(
                          spacing: 18, runSpacing: 18,
                          children: [
                            SizedBox(width: width, child: _choice('Workshop *', ['YES','NO'], workshop, (v) => setState(() => workshop = v))),
                            SizedBox(width: width, child: _choice('Food *', ['VEG','NON-VEG'], food, (v) => setState(() => food = v))),
                          ],
                        );
                      })),
                    const SizedBox(height: 18),
                    _paymentSection(),
                    const SizedBox(height: 18),
                    _submitBar(),
                  ]),
                ),
              ),
            ),
          ),
          const SiteFooter(),
        ]),
      ),
    );
  }

  Widget _section(String number, String title, String hint, Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppTheme.border),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(builder: (_, c) {
        final stacked = c.maxWidth < 650;
        final titleWidget = Text('$number • $title',
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900));
        final hintWidget = Text(hint, style: const TextStyle(color: AppTheme.muted, fontSize: 11, fontWeight: FontWeight.w700));
        if (stacked) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          titleWidget, const SizedBox(height: 5), hintWidget,
        ]);
        }
        return Row(children: [titleWidget, const Spacer(), hintWidget]);
      }),
      const SizedBox(height: 22),
      child,
    ]),
  );

  Widget _field(TextEditingController c, String label, String hint, {bool phone = false, bool email = false}) =>
      TextFormField(
        controller: c,
        keyboardType: email ? TextInputType.emailAddress : phone ? TextInputType.phone : TextInputType.text,
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return 'Required';
          if (phone && !RegExp(r'^[0-9]{10}$').hasMatch(value)) return 'Enter a valid 10-digit number';
          if (email && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Enter a valid email';
          return null;
        },
        decoration: InputDecoration(labelText: label, hintText: hint),
      );

  Widget _choice(String label, List<String> values, String value, ValueChanged<String> onChange) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 9),
        Wrap(spacing: 9, runSpacing: 9, children: values.map((v) => InkWell(
          onTap: () => onChange(v),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            decoration: BoxDecoration(
              color: value == v ? const Color(0xFFEAFBFA) : Colors.white,
              border: Border.all(color: value == v ? AppTheme.teal : AppTheme.border, width: value == v ? 2 : 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(value == v ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18, color: value == v ? AppTheme.teal : Colors.grey),
              const SizedBox(width: 7),
              Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
          ),
        )).toList()),
      ]);

  Widget _eventGrid(List<Event> list, String selected, ValueChanged<Event> onSelect) =>
      LayoutBuilder(builder: (_, c) {
        final cols = c.maxWidth >= 800 ? 2 : 1;
        return GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: cols == 2 ? 3.0 : 2.7,
          ),
          itemBuilder: (_, i) => EventCard(
            event: list[i],
            selectable: true,
            selected: selected == list[i].name,
            onTap: () => onSelect(list[i]),
          ),
        );
      });

  Widget _paymentSection() => _section('05', 'Payment', 'Complete payment before submitting',
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF1F6FA), borderRadius: BorderRadius.circular(14)),
        child: const Text('Payment through any one of the given QR below.\nPlease add your own QR images to assets/images/ using the names payment_qr_1.png and payment_qr_2.png.',
          style: TextStyle(color: AppTheme.muted, height: 1.45)),
      ),
      const SizedBox(height: 18),
      LayoutBuilder(builder: (_, c) {
        final two = c.maxWidth >= 700;
        final width = two ? (c.maxWidth - 16) / 2 : c.maxWidth;
        return Wrap(
          spacing: 16, runSpacing: 16,
          children: [
            _qr(width, 'Payment QR – 1', 'assets/images/payment_qr_1.jpeg'),
            _qr(width, 'Payment QR – 2', 'assets/images/payment_qr_2.jpeg'),
          ],
        );
      }),
      const SizedBox(height: 20),
      _field(transaction, 'TRANSACTION ID *', 'Enter your UPI transaction ID'),
      const SizedBox(height: 6),
      const Text('Enter the transaction/reference ID shown in your payment application.',
        style: TextStyle(color: AppTheme.muted, fontSize: 12)),
      const SizedBox(height: 18),
      const Text('Upload payment screenshot *', style: TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 5),
      const Text('JPG, JPEG, PNG or WEBP. Maximum 800 KB because the image is stored directly in Firestore.',
        style: TextStyle(color: AppTheme.muted, fontSize: 12)),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: loading ? null : _pick,
        icon: const Icon(Icons.upload_file),
        label: Text(screenshot == null ? 'Choose File' : screenshotName),
      ),
      if (screenshot != null) ...[
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppTheme.lightBg, borderRadius: BorderRadius.circular(14)),
          child: Image.memory(screenshot!, fit: BoxFit.contain),
        ),
      ],
    ]));

  Widget _qr(double width, String title, String asset) => Container(
    width: width,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(border: Border.all(color: AppTheme.border), borderRadius: BorderRadius.circular(15)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      Container(
        height: 290,
        width: double.infinity,
        color: const Color(0xFFF1F5FB),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Your payment QR image will appear here.', textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.muted)),
            ),
          ),
        ),
      ),
    ]),
  );

  Widget _submitBar() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppTheme.dark, borderRadius: BorderRadius.circular(18)),
    child: LayoutBuilder(builder: (_, c) {
      final stacked = c.maxWidth < 650;
      final button = FilledButton(
        onPressed: loading ? null : _submit,
        style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16)),
        child: loading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('Submit Registration →', style: TextStyle(fontWeight: FontWeight.w900)),
      );
      if (stacked) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('READY?', style: TextStyle(color: AppTheme.teal, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 5),
        const Text('Submit your B’ELITEZ 2K26 registration.',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16), button,
      ]);
      return Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('READY?', style: TextStyle(color: AppTheme.teal, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          SizedBox(height: 5),
          Text('Submit your B’ELITEZ 2K26 registration.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ])),
        button,
      ]);
    }),
  );

  Future<void> _pick() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > 800 * 1024) {
        if (mounted) _msg('Image must be 800 KB or smaller.', error: true);
        return;
      }
      setState(() {
        screenshot = bytes;
        screenshotName = file.name;
        screenshotType = _mime(file.name);
      });
    } catch (e) {
      if (mounted) _msg('Unable to select image: $e', error: true);
    }
  }

  String _mime(String name) {
    final x = name.toLowerCase();
    if (x.endsWith('.png')) return 'image/png';
    if (x.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    if (year.isEmpty || workshop.isEmpty || food.isEmpty) {
      _msg('Please complete Year, Workshop and Food.', error: true); return;
    }
    if (technical.isEmpty && nonTechnical.isEmpty) {
      _msg('Select at least one event.', error: true); return;
    }
    if (screenshot == null) {
      _msg('Payment screenshot is required.', error: true); return;
    }

    setState(() => loading = true);
    try {
      final id = await FirebaseService.instance.createRegistration(
        name: name.text,
        college: college.text,
        department: department.text,
        contact: contact.text,
        email: email.text,
        year: year,
        technicalEvent: technical.isEmpty ? '-' : technical,
        nonTechnicalEvent: nonTechnical.isEmpty ? '-' : nonTechnical,
        workshop: workshop,
        food: food,
        transactionId: transaction.text,
        paymentBytes: screenshot!,
        fileName: screenshotName,
        contentType: screenshotType,
      );
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Registration Successful'),
          content: Text('Your registration ID is:\n$id\n\nPayment status: PENDING.'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/register-home', (_) => false),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) _msg('Registration failed: $e', error: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _msg(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
    ));
  }
}

class _Notice extends StatelessWidget {
  const _Notice();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    color: const Color(0xFFFFF8F0),
    child: const Center(
      child: Text.rich(TextSpan(children: [
        TextSpan(text: '📌 Important: ', style: TextStyle(fontWeight: FontWeight.w900)),
        TextSpan(text: 'Accommodation will not be provided.'),
      ])),
    ),
  );
}
