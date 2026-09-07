import 'dart:typed_data';

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
    if (FirebaseAuth.instance.currentUser == null) {
      return const _AdminRedirect();
    }

    return Scaffold(
      appBar: const SiteHeader(),
      body: StreamBuilder<List<Registration>>(
        stream: FirebaseService.instance.registrationsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _errorState(snapshot.error);
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = snapshot.data!;
          final filtered = all.where(_matches).toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 12 : 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _hero(all.length, filtered.length),
                    const SizedBox(height: 20),
                    _summaryCards(all),
                    const SizedBox(height: 20),
                    _filters(all),
                    const SizedBox(height: 20),
                    _records(filtered),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _errorState(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load registrations.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _hero(int total, int showing) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1450),
        child: LayoutBuilder(
          builder: (_, c) {
            final compact = c.maxWidth < 760;

            final title = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'ADMINISTRATION',
                  style: TextStyle(
                    color: AppTheme.teal,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Registration Dashboard',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Manage and analyse B'ELITEZ 2K26 registrations.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppTheme.muted),
                ),
              ],
            );

            final stats = Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _stat(total, 'Total'),
                _stat(showing, 'Showing'),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 18),
                  stats,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: title),
                const SizedBox(width: 18),
                stats,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _stat(int number, String label) {
    return Container(
      width: 135,
      height: 88,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$number',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppTheme.teal,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _summaryCards(List<Registration> all) {
    int paid = all.where((r) => _upper(r.paymentStatus) == 'PAID').length;
    int pending =
        all.where((r) => _upper(r.paymentStatus) == 'PENDING').length;
    int rejected =
        all.where((r) => _upper(r.paymentStatus) == 'REJECTED').length;
    int registered =
        all.where((r) => _upper(r.status) == 'REGISTERED').length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1450),
        child: LayoutBuilder(
          builder: (_, c) {
            final count = c.maxWidth >= 1100
                ? 4
                : c.maxWidth >= 700
                ? 2
                : 1;

            final cards = [
              _summaryCard('PAID', paid, Icons.check_circle_outline),
              _summaryCard('PENDING', pending, Icons.schedule),
              _summaryCard('REJECTED', rejected, Icons.cancel_outlined),
              _summaryCard(
                'REGISTERED',
                registered,
                Icons.how_to_reg_outlined,
              ),
            ];

            return GridView.count(
              crossAxisCount: count,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: count == 1 ? 4.0 : 2.7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: cards,
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard(String title, int count, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.teal, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters(List<Registration> all) {
    List<String> unique(
        Iterable<String> values,
        String first,
        ) {
      final valuesSet = values
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      return [first, ...valuesSet];
    }

    final colleges = unique(all.map((e) => e.college), 'All Colleges');
    final departments =
    unique(all.map((e) => e.department), 'All Departments');
    final years = unique(all.map((e) => e.year), 'All Years');
    final technical =
    unique(all.map((e) => e.technicalEvent), 'All Technical Events');
    final nonTechnical = unique(
      all.map((e) => e.nonTechnicalEvent),
      'All Non-Technical Events',
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1450),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (_, c) {
                    final columns = c.maxWidth >= 1100
                        ? 4
                        : c.maxWidth >= 650
                        ? 2
                        : 1;

                    return GridView.count(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: columns == 1 ? 5.0 : 3.9,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            hintText: 'Name, college, email, contact...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              search = value.trim().toLowerCase();
                            });
                          },
                        ),
                        _drop(
                          collegeFilter,
                          colleges,
                              (v) => setState(
                                () => collegeFilter = v ?? 'All Colleges',
                          ),
                        ),
                        _drop(
                          deptFilter,
                          departments,
                              (v) => setState(
                                () => deptFilter = v ?? 'All Departments',
                          ),
                        ),
                        _drop(
                          yearFilter,
                          years,
                              (v) => setState(
                                () => yearFilter = v ?? 'All Years',
                          ),
                        ),
                        _drop(
                          techFilter,
                          technical,
                              (v) => setState(
                                () => techFilter = v ?? 'All Technical Events',
                          ),
                        ),
                        _drop(
                          nonTechFilter,
                          nonTechnical,
                              (v) => setState(
                                () => nonTechFilter =
                                v ?? 'All Non-Technical Events',
                          ),
                        ),
                        _drop(
                          workshopFilter,
                          const ['All', 'YES', 'NO'],
                              (v) => setState(
                                () => workshopFilter = v ?? 'All',
                          ),
                        ),
                        _drop(
                          foodFilter,
                          const ['All', 'VEG', 'NON-VEG'],
                              (v) => setState(
                                () => foodFilter = v ?? 'All',
                          ),
                        ),
                        _drop(
                          paymentFilter,
                          const [
                            'All Payment Status',
                            'PENDING',
                            'PAID',
                            'REJECTED',
                          ],
                              (v) => setState(
                                () => paymentFilter =
                                v ?? 'All Payment Status',
                          ),
                        ),
                        _drop(
                          statusFilter,
                          const [
                            'All Registration Status',
                            'REGISTERED',
                            'CANCELLED',
                          ],
                              (v) => setState(
                                () => statusFilter =
                                v ?? 'All Registration Status',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Clear Filters'),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        ExportService.download(
                          all.where(_matches).toList(),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download Excel'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/admin/login',
                          );
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drop(
      String value,
      List<String> values,
      ValueChanged<String?> onChanged,
      ) {
    final safeValue = values.contains(value) ? value : values.first;

    return DropdownButtonFormField<String>(
      initialValue: safeValue,
      isExpanded: true,
      decoration: const InputDecoration(),
      items: values
          .map(
            (v) => DropdownMenuItem<String>(
          value: v,
          child: Text(
            v,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }

  bool _matches(Registration r) {
    final q = search;

    final text = [
      r.registrationId,
      r.name,
      r.college,
      r.department,
      r.year,
      r.contact,
      r.email,
      r.technicalEvent,
      r.nonTechnicalEvent,
      r.workshop,
      r.food,
      r.transactionId,
      r.paymentStatus,
      r.status,
    ].join(' ').toLowerCase();

    return (q.isEmpty || text.contains(q)) &&
        (collegeFilter == 'All Colleges' || r.college == collegeFilter) &&
        (deptFilter == 'All Departments' || r.department == deptFilter) &&
        (yearFilter == 'All Years' || r.year == yearFilter) &&
        (techFilter == 'All Technical Events' ||
            r.technicalEvent == techFilter) &&
        (nonTechFilter == 'All Non-Technical Events' ||
            r.nonTechnicalEvent == nonTechFilter) &&
        (workshopFilter == 'All' || r.workshop == workshopFilter) &&
        (foodFilter == 'All' || r.food == foodFilter) &&
        (paymentFilter == 'All Payment Status' ||
            r.paymentStatus == paymentFilter) &&
        (statusFilter == 'All Registration Status' ||
            r.status == statusFilter);
  }

  void _clear() {
    setState(() {
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
  }

  Widget _records(List<Registration> rows) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1450),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Registration Records',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppTheme.teal.withOpacity(.08),
                      ),
                      child: Text(
                        '${rows.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (rows.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text('No registrations match the selected filters.'),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 14,
                    horizontalMargin: 14,
                    headingRowHeight: 52,
                    dataRowMinHeight: 62,
                    dataRowMaxHeight: 76,
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFEAF1F5),
                    ),
                    columns: const [
                      DataColumn(label: _Header('ID')),
                      DataColumn(label: _Header('Name')),
                      DataColumn(label: _Header('College')),
                      DataColumn(label: _Header('Department')),
                      DataColumn(label: _Header('Year')),
                      DataColumn(label: _Header('Contact')),
                      DataColumn(label: _Header('Email')),
                      DataColumn(label: _Header('Technical')),
                      DataColumn(label: _Header('Non-Technical')),
                      DataColumn(label: _Header('Workshop')),
                      DataColumn(label: _Header('Food')),
                      DataColumn(label: _Header('Transaction')),
                      DataColumn(label: _Header('Payment')),
                      DataColumn(label: _Header('Status')),
                      DataColumn(label: _Header('Registered')),
                      DataColumn(label: _Header('Actions')),
                    ],
                    rows: rows.map(_row).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _row(Registration r) {
    return DataRow(
      cells: [
        DataCell(_cell(r.registrationId, 110)),
        DataCell(_cell(r.name, 150)),
        DataCell(_cell(r.college, 180)),
        DataCell(_cell(r.department, 150)),
        DataCell(_cell(r.year, 65)),
        DataCell(_cell(r.contact, 120)),
        DataCell(_cell(r.email, 190)),
        DataCell(_cell(r.technicalEvent, 180)),
        DataCell(_cell(r.nonTechnicalEvent, 180)),
        DataCell(_cell(r.workshop, 85)),
        DataCell(_cell(r.food, 90)),
        DataCell(_cell(r.transactionId, 150)),
        DataCell(
          SizedBox(
            width: 145,
            child: Row(
              children: [
                Expanded(child: _chip(r.paymentStatus)),
                if (r.hasPaymentScreenshot)
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: 'View payment screenshot',
                      onPressed: () => _showImage(r),
                      icon: const Icon(Icons.image_outlined, size: 20),
                    ),
                  ),
              ],
            ),
          ),
        ),
        DataCell(SizedBox(width: 115, child: _chip(r.status))),
        DataCell(
          _cell(
            r.registeredAt == null
                ? '-'
                : DateFormat(
              'yyyy-MM-dd HH:mm',
            ).format(r.registeredAt!),
            145,
          ),
        ),
        DataCell(
          SizedBox(
            width: 60,
            child: PopupMenuButton<String>(
              tooltip: 'Actions',
              icon: const Icon(Icons.more_vert),
              onSelected: (v) async {
                await _handleAction(v, r);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'view',
                  child: Text('View all details'),
                ),
                PopupMenuItem(
                  value: 'paid',
                  child: Text('Mark Payment PAID'),
                ),
                PopupMenuItem(
                  value: 'pending',
                  child: Text('Mark Payment PENDING'),
                ),
                PopupMenuItem(
                  value: 'rejected',
                  child: Text('Reject Payment'),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'registered',
                  child: Text('Mark REGISTERED'),
                ),
                PopupMenuItem(
                  value: 'cancelled',
                  child: Text('Mark CANCELLED'),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cell(String value, double width) {
    return SizedBox(
      width: width,
      child: Tooltip(
        message: value.isEmpty ? '-' : value,
        child: Text(
          value.isEmpty ? '-' : value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }

  Widget _chip(String value) {
    final upper = _upper(value);
    final good = upper == 'PAID' || upper == 'REGISTERED';

    return Container(
      constraints: const BoxConstraints(minWidth: 65, maxWidth: 105),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: good
            ? Colors.green.withOpacity(.10)
            : Colors.orange.withOpacity(.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value.isEmpty ? '-' : value,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: good ? Colors.green.shade700 : Colors.orange.shade800,
        ),
      ),
    );
  }

  Future<void> _handleAction(String action, Registration r) async {
    try {
      if (action == 'view') {
        await _showDetails(r);
      } else if (action == 'paid' ||
          action == 'rejected' ||
          action == 'pending') {
        await FirebaseService.instance.updatePaymentStatus(
          r.docId,
          action,
        );
      } else if (action == 'registered' || action == 'cancelled') {
        await FirebaseService.instance.updateRegistrationStatus(
          r.docId,
          action,
        );
      } else if (action == 'delete') {
        await FirebaseService.instance.deleteRegistration(r.docId);
      }

      if (!mounted) return;

      if (action != 'view') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action completed: $action')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action failed: $e')),
      );
    }
  }

  Future<void> _showDetails(Registration r) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Complete Registration Details',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: SizedBox(
            width: 850,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _detailSection(
                    'Registration',
                    [
                      _detail('Document ID', r.docId),
                      _detail('Registration ID', r.registrationId),
                      _detail('Registration Status', r.status),
                      _detail(
                        'Registered At',
                        r.registeredAt == null
                            ? '-'
                            : DateFormat(
                          'yyyy-MM-dd HH:mm:ss',
                        ).format(r.registeredAt!),
                      ),
                    ],
                  ),
                  _detailSection(
                    'Participant',
                    [
                      _detail('Name', r.name),
                      _detail('College', r.college),
                      _detail('Department', r.department),
                      _detail('Year', r.year),
                      _detail('Contact', r.contact),
                      _detail('Email', r.email),
                    ],
                  ),
                  _detailSection(
                    'Events & Options',
                    [
                      _detail('Technical Event', r.technicalEvent),
                      _detail(
                        'Non-Technical Event',
                        r.nonTechnicalEvent,
                      ),
                      _detail('Workshop', r.workshop),
                      _detail('Food', r.food),
                    ],
                  ),
                  _detailSection(
                    'Payment',
                    [
                      _detail('Transaction ID', r.transactionId),
                      _detail('Payment Status', r.paymentStatus),
                      _detail(
                        'Payment Screenshot',
                        r.hasPaymentScreenshot ? 'Available' : 'Not available',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (r.hasPaymentScreenshot)
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _showImage(r);
                },
                icon: const Icon(Icons.image_outlined),
                label: const Text('View Screenshot'),
              ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.teal,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: LayoutBuilder(
        builder: (_, c) {
          if (c.maxWidth < 520) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  softWrap: true,
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? '-' : value,
                  softWrap: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showImage(Registration r) async {
    if (!r.hasPaymentScreenshot) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Payment Screenshot'),
          content: SizedBox(
            width: 700,
            height: 520,
            child: FutureBuilder<Uint8List?>(
              future: FirebaseService.instance.getPaymentScreenshot(r),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Unable to load the payment screenshot.\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final bytes = snapshot.data;

                if (bytes == null || bytes.isEmpty) {
                  return const Center(
                    child: Text('Payment screenshot is not available.'),
                  );
                }

                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4,
                  child: Center(
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const Text(
                          'The stored screenshot could not be displayed.',
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _upper(String value) => value.trim().toUpperCase();
}

class _Header extends StatelessWidget {
  final String text;

  const _Header(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w900),
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
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/admin/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
