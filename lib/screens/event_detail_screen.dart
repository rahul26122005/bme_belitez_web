import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/theme.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

class EventDetailScreen extends StatelessWidget {
  final String slug;

  const EventDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    final match = events.where((e) => e.slug == slug).toList();
    final event = match.isEmpty ? null : match.first;

    if (event == null) {
      return Scaffold(
        appBar: const SiteHeader(showBack: true),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Event not found',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: const SiteHeader(showBack: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _hero(context, event),
            _rules(context, event),
            _register(context, event),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context, Event event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 38, 16, 42),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.navy, AppTheme.navy2],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = constraints.maxWidth;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.icon,
                    style: TextStyle(
                      fontSize: width < 450 ? 44 : 55,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    event.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppTheme.teal,
                      fontWeight: FontWeight.w900,
                      letterSpacing: width < 450 ? 1.2 : 2,
                      fontSize: width < 450 ? 11 : 13,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    event.name,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width < 360
                          ? 28
                          : width < 500
                              ? 34
                              : width < 800
                                  ? 42
                                  : 50,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    softWrap: true,
                    style: TextStyle(
                      color: const Color(0xFFB4C6D9),
                      fontSize: width < 450 ? 14 : 17,
                      height: 1.55,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _rules(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 22, 10, 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(20),
            ),
            child: LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EVENT INFORMATION',
                      style: TextStyle(
                        color: AppTheme.teal,
                        fontWeight: FontWeight.w900,
                        letterSpacing: width < 450 ? 1.2 : 2,
                        fontSize: width < 450 ? 10 : 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Rules & Regulations',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: width < 450 ? 24 : 30,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (event.rules.isEmpty)
                      const Text(
                        'Rules and regulations will be announced by the event coordinators.',
                        softWrap: true,
                      ),
                    ...event.rules.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE7FAF7),
                              ),
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: AppTheme.teal,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value,
                                softWrap: true,
                                style: TextStyle(
                                  color: AppTheme.muted,
                                  height: 1.5,
                                  fontSize: width < 450 ? 13 : 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _register(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.navy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: LayoutBuilder(
              builder: (_, constraints) {
                final stacked = constraints.maxWidth < 650;

                final text = const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WANT TO PARTICIPATE?',
                      style: TextStyle(
                        color: AppTheme.teal,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Select this event in the registration form.',
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                );

                final button = SizedBox(
                  width: stacked ? double.infinity : null,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/register'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.teal,
                      foregroundColor: AppTheme.dark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'Register →',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );

                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text,
                      const SizedBox(height: 16),
                      button,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: text),
                    const SizedBox(width: 16),
                    button,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
