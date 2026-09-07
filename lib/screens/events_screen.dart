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
    final technical =
        events.where((e) => e.category == 'Technical').toList();

    final nonTechnical =
        events.where((e) => e.category == 'Non-Technical').toList();

    final workshop = events
        .where((e) => e.category.toLowerCase() == 'workshop')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: const SiteHeader(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _hero(context),
              _section(context, 'Technical Events', technical),
              _section(context, 'Non-Technical Events', nonTechnical),
              if (workshop.isNotEmpty)
                _section(context, 'Workshop', workshop),
              const SiteFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 38),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.navy, AppTheme.navy2],
        ),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final size = constraints.maxWidth < 360
              ? 27.0
              : constraints.maxWidth < 500
                  ? 31.0
                  : constraints.maxWidth < 800
                      ? 38.0
                      : 48.0;

          return Text(
            'B’ELITEZ 2K26 Events',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Colors.white,
              fontSize: size,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          );
        },
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    List<Event> list,
  ) {
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
              builder: (_, constraints) {
                final width = constraints.maxWidth;

                final columns = width >= 1020
                    ? 3
                    : width >= 620
                        ? 2
                        : 1;

                final gap = 12.0;
                final cardWidth = columns == 1
                    ? width
                    : (width - gap * (columns - 1)) / columns;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        title,
                        softWrap: true,
                        style: TextStyle(
                          color: AppTheme.text,
                          fontSize: width < 450 ? 22 : 30,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: list
                          .map(
                            (event) => SizedBox(
                              width: cardWidth,
                              child: EventCard(event: event),
                            ),
                          )
                          .toList(),
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
