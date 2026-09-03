import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/registration.dart';
import '../services/export_service.dart';
import '../services/firebase_service.dart';
import '../utils/theme.dart';
import '../widgets/site_header.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String search = '';
  String paymentFilter = 'All Payment Status';
  String statusFilter = 'All Registration Status';
  String collegeFilter = 'All Colleges';
  String deptFilter = 'All Departments';
  String yearFilter = 'All Years';
  String techFilter = 'All Technical Events';
  String nonTechFilter = 'All Non-Technical Events';
  String workshopFilter = 'All';
  String foodFilter = 'All';

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) return const _AdminRedirect();

    return Scaffold(
      appBar: const SiteHeader(),
      body: StreamBuilder<List<Registration>>(
        stream: FirebaseService.instance.registrationsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final all = snapshot.data!;
          final filtered = all.where(_matches).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 35, 18, 50),
            child: Column(children: [
              _hero(all.length, filtered.length),
              const SizedBox(height: 24),
              _filters(all),
              const SizedBox(height: 24),
              _records(filtered),
            ]),
          );
        },
      ),
    );
  }

  Widget _hero(int total, int showing) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1450),
      child: LayoutBuilder(builder: (_, c) {
        final stacked = c.maxWidth < 800;
        final stats = Row(mainAxisSize: MainAxisSize.min, children: [
          _stat(total, 'Total'),
          const SizedBox(width: 12),
          _stat(showing, 'Showing'),
        ]);
        if (stacked) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ADMINISTRATION', style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 8),
          const Text('Registration Dashboard', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text("Manage and analyse B'ELITEZ 2K26 registrations.", style: TextStyle(color: AppTheme.muted)),
          const SizedBox(height: 18), stats,
        ]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ADMINISTRATION', style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
            SizedBox(height: 8),
            Text('Registration Dashboard', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900)),
            SizedBox(height: 6),
            Text("Manage and analyse B'ELITEZ 2K26 registrations.", style: TextStyle(color: AppTheme.muted, fontSize: 16)),
          ])),
          stats,
        ]);
      }),
    ),
  );

  Widget _stat(int n, String label) => Container(
    width: 140, height: 95,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('$n', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.teal)),
      Text(label, style: const TextStyle(color: AppTheme.muted)),
    ]),
  );

  Widget _filters(List<Registration> all) {
    List<String> unique(Iterable<String> values, String first) {
      final x = values.where((v) => v.trim().isNotEmpty).toSet().toList()..sort();
      return [first, ...x];
    }
    final colleges = unique(all.map((e) => e.college), 'All Colleges');
    final depts = unique(all.map((e) => e.department), 'All Departments');
    final years = unique(all.map((e) => e.year), 'All Years');
    final techs = unique(all.map((e) => e.technicalEvent), 'All Technical Events');
    final nonTechs = unique(all.map((e) => e.nonTechnicalEvent), 'All Non-Technical Events');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1450),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppTheme.border)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              LayoutBuilder(builder: (_, c) {
                final n = c.maxWidth > 1050 ? 4 : c.maxWidth > 700 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: n,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12, mainAxisSpacing: 12,
                  childAspectRatio: 4.6,
                  children: [
                    TextField(decoration: const InputDecoration(labelText: 'Search', hintText: 'Name, college, email...'),
                      onChanged: (v) => setState(() => search = v.trim().toLowerCase())),
                    _drop(collegeFilter, colleges, (v) => setState(() => collegeFilter = v!)),
                    _drop(deptFilter, depts, (v) => setState(() => deptFilter = v!)),
                    _drop(yearFilter, years, (v) => setState(() => yearFilter = v!)),
                    _drop(techFilter, techs, (v) => setState(() => techFilter = v!)),
                    _drop(nonTechFilter, nonTechs, (v) => setState(() => nonTechFilter = v!)),
                    _drop(workshopFilter, const ['All','YES','NO'], (v) => setState(() => workshopFilter = v!)),
                    _drop(foodFilter, const ['All','VEG','NON-VEG'], (v) => setState(() => foodFilter = v!)),
                    _drop(paymentFilter, const ['All Payment Status','PENDING','PAID','REJECTED'], (v) => setState(() => paymentFilter = v!)),
                    _drop(statusFilter, const ['All Registration Status','REGISTERED','CANCELLED'], (v) => setState(() => statusFilter = v!)),
                  ],
                );
              }),
              const SizedBox(height: 16),
              Wrap(spacing: 10, runSpacing: 10, children: [
                OutlinedButton.icon(onPressed: _clear, icon: const Icon(Icons.refresh), label: const Text('Clear Filters')),
                FilledButton.icon(
                  onPressed: () => ExportService.download(all.where(_matches).toList()),
                  icon: const Icon(Icons.download),
                  label: const Text('Download Excel'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) Navigator.pushReplacementNamed(context, '/admin/login');
                  },
                  icon: const Icon(Icons.logout), label: const Text('Logout'),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _drop(String value, List<String> values, ValueChanged<String?> onChanged) =>
      DropdownButtonFormField<String>(
        initialValue: values.contains(value) ? value : values.first,
        decoration: const InputDecoration(),
        items: values.map((v) => DropdownMenuItem(value: v, child: Text(v, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: onChanged,
      );

  bool _matches(Registration r) {
    final q = search;
    final text = '${r.name} ${r.college} ${r.contact} ${r.email}'.toLowerCase();
    return (q.isEmpty || text.contains(q))
      && (collegeFilter == 'All Colleges' || r.college == collegeFilter)
      && (deptFilter == 'All Departments' || r.department == deptFilter)
      && (yearFilter == 'All Years' || r.year == yearFilter)
      && (techFilter == 'All Technical Events' || r.technicalEvent == techFilter)
      && (nonTechFilter == 'All Non-Technical Events' || r.nonTechnicalEvent == nonTechFilter)
      && (workshopFilter == 'All' || r.workshop == workshopFilter)
      && (foodFilter == 'All' || r.food == foodFilter)
      && (paymentFilter == 'All Payment Status' || r.paymentStatus == paymentFilter)
      && (statusFilter == 'All Registration Status' || r.status == statusFilter);
  }

  void _clear() => setState(() {
    search = '';
    paymentFilter = 'All Payment Status';
    statusFilter = 'All Registration Status';
    collegeFilter = 'All Colleges';
    deptFilter = 'All Departments';
    yearFilter = 'All Years';
    techFilter = 'All Technical Events';
    nonTechFilter = 'All Non-Technical Events';
    workshopFilter = 'All';
    foodFilter = 'All';
  });

  Widget _records(List<Registration> rows) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1450),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppTheme.border)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Registration Records • ${rows.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFEAF1F5)),
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('College')),
                DataColumn(label: Text('Technical')),
                DataColumn(label: Text('Non-Technical')),
                DataColumn(label: Text('Workshop')),
                DataColumn(label: Text('Food')),
                DataColumn(label: Text('Transaction')),
                DataColumn(label: Text('Payment')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Registered')),
                DataColumn(label: Text('Actions')),
              ],
              rows: rows.map(_row).toList(),
            ),
          ),
        ]),
      ),
    ),
  );

  DataRow _row(Registration r) => DataRow(cells: [
    DataCell(Text(r.registrationId)),
    DataCell(Text(r.name)),
    DataCell(Text(r.college)),
    DataCell(Text(r.technicalEvent)),
    DataCell(Text(r.nonTechnicalEvent)),
    DataCell(Text(r.workshop)),
    DataCell(Text(r.food)),
    DataCell(Text(r.transactionId)),
    DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
      _chip(r.paymentStatus),
      if (r.paymentBytes != null)
        IconButton(tooltip: 'View payment screenshot', onPressed: () => _showImage(r), icon: const Icon(Icons.image_outlined)),
    ])),
    DataCell(_chip(r.status)),
    DataCell(Text(r.registeredAt == null ? '-' : DateFormat('yyyy-MM-dd HH:mm').format(r.registeredAt!))),
    DataCell(PopupMenuButton<String>(
      onSelected: (v) async {
        try {
          if (v == 'paid' || v == 'rejected' || v == 'pending') {
            await FirebaseService.instance.updatePaymentStatus(r.docId, v);
          } else if (v == 'registered' || v == 'cancelled') {
            await FirebaseService.instance.updateRegistrationStatus(r.docId, v);
          } else if (v == 'delete') {
            await FirebaseService.instance.deleteRegistration(r.docId);
          }
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Action failed: $e')));
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'paid', child: Text('Mark Payment PAID')),
        PopupMenuItem(value: 'pending', child: Text('Mark Payment PENDING')),
        PopupMenuItem(value: 'rejected', child: Text('Reject Payment')),
        PopupMenuDivider(),
        PopupMenuItem(value: 'registered', child: Text('Mark REGISTERED')),
        PopupMenuItem(value: 'cancelled', child: Text('Mark CANCELLED')),
        PopupMenuDivider(),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    )),
  ]);

  Widget _chip(String text) {
    final good = text == 'PAID' || text == 'REGISTERED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: good ? Colors.green.withOpacity(.10) : Colors.orange.withOpacity(.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900,
        color: good ? Colors.green.shade700 : Colors.orange.shade800)),
    );
  }

  void _showImage(Registration r) {
    final bytes = r.paymentBytes;
    if (bytes == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Screenshot'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 650),
          child: Image.memory(bytes, fit: BoxFit.contain),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _AdminRedirect extends StatefulWidget {
  const _AdminRedirect();
  @override
  State<_AdminRedirect> createState() => _AdminRedirectState();
}
class _AdminRedirectState extends State<_AdminRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/admin/login');
    });
  }
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}
