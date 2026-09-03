import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/theme.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

class EventDetailScreen extends StatelessWidget {
  final String slug;
  const EventDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final match = events.where((e) => e.slug == slug).toList();
    final event = match.isEmpty ? null : match.first;

    if (event == null) {
      return Scaffold(
        appBar: const SiteHeader(showBack: true),
        body: const Center(child: Text('Event not found')),
      );
    }

    return Scaffold(
      appBar: const SiteHeader(showBack: true),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 60),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.navy, AppTheme.navy2]),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(event.icon, style: const TextStyle(fontSize: 55)),
                  const SizedBox(height: 18),
                  Text(event.category.toUpperCase(),
                    style: const TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text(event.name,
                    style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  Text(event.description,
                    style: const TextStyle(color: Color(0xFFB4C6D9), fontSize: 17, height: 1.55)),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 45),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('EVENT INFORMATION',
                        style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      const SizedBox(height: 8),
                      const Text('Rules & Regulations',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 22),
                      ...event.rules.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            width: 26, height: 26,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE7FAF7)),
                            child: Text('${entry.key + 1}',
                              style: const TextStyle(color: AppTheme.teal, fontSize: 11, fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(entry.value,
                            style: const TextStyle(color: AppTheme.muted, height: 1.5, fontSize: 15))),
                        ]),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.navy,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: LayoutBuilder(builder: (_, c) {
                      final stacked = c.maxWidth < 600;
                      final children = [
                        const Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('WANT TO PARTICIPATE?',
                              style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                            SizedBox(height: 7),
                            Text('Select this event in the registration form.',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          ],
                        )),
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark),
                          child: Text('Register for ${event.name} →', style: const TextStyle(fontWeight: FontWeight.w900)),
                        ),
                      ];
                      if (stacked) {
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          children[0],
                          const SizedBox(height: 18),
                          children[1],
                        ]);
                      }
                      return Row(children: children);
                    }),
                  ),
                ]),
              ),
            ),
          ),
          const SiteFooter(),
        ]),
      ),
    );
  }
}
