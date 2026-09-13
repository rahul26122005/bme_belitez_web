import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/theme.dart';
import '../widgets/event_card.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final technical = events.where((e) => e.category == 'Technical').toList();
    final nonTechnical = events.where((e) => e.category == 'Non-Technical').toList();
    final workshop = events.where((e) => e.category.toLowerCase() == 'workshop').toList();

    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      appBar: const SiteHeader(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _Notice(),
              _hero(),
              _section('Technical Events', technical),
              _section('Non-Technical Events', nonTechnical),
              if (workshop.isNotEmpty) _section('Workshop', workshop),
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 38),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.navy, AppTheme.navy2]),
      ),
      child: LayoutBuilder(
        builder: (_, c) => Text(
          'B’ELITEZ 2K26 Events',
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: c.maxWidth < 360 ? 27 : c.maxWidth < 500 ? 31 : c.maxWidth < 800 ? 38 : 48,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<Event> list) {
    if (list.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 18, 10, 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(18),
            ),
            child: LayoutBuilder(
              builder: (_, c) {
                final width = c.maxWidth;
                final columns = width >= 1020 ? 3 : width >= 620 ? 2 : 1;
                const gap = 12.0;
                final cardWidth = columns == 1
                    ? width
                    : (width - gap * (columns - 1)) / columns;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      style: TextStyle(
                        color: AppTheme.text,
                        fontSize: width < 450 ? 22 : 30,
                        height: 1.15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final event in list)
                          SizedBox(
                            width: cardWidth,
                            child: EventCard(event: event),
                          ),
                      ],
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
              '📌 Important: There is no specific deadline for registration at this time. Registration will remain open until further notice.',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.green,
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

