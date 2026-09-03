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

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 65, 24, 55),
            color: AppTheme.navy,
            child: const Center(
              child: Text('B’ELITEZ 2K26 Events',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
            ),
          ),
          _section(context, 'Technical Events', technical),
          _section(context, 'Non-Technical Events', nonTechnical),
          _section(context, 'Workshop', [events.last]),
          const SiteFooter(),
        ]),
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Event> list) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.text)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (_, c) {
            final n = c.maxWidth > 900 ? 3 : c.maxWidth > 600 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: n,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: n == 1 ? 1.7 : 1.2,
              ),
              itemBuilder: (_, i) => EventCard(event: list[i]),
            );
          }),
        ],
      ),
    ),
  );
}
