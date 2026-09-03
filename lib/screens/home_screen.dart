import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/theme.dart';
import '../widgets/event_card.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

class SymposiumHomeScreen extends StatelessWidget {
  const SymposiumHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _hero(context),
            _notice(),
            _events(context),
            _cta(context),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 70, 24, 70),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppTheme.navy, Color(0xFF0A1B31), Color(0xFF071221)],
      ),
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1250),
        child: LayoutBuilder(builder: (_, c) {
          final stacked = c.maxWidth < 900;
          final titleSize = c.maxWidth < 500 ? 68.0 : 96.0;
          final content = Column(
            crossAxisAlignment: stacked ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              const Text('MAHENDRA COLLEGE OF ENGINEERING',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 5),
              const Text('DEPARTMENT OF BIOMEDICAL ENGINEERING',
                style: TextStyle(color: Color(0xFFB7C7D9), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.6)),
              const SizedBox(height: 20),
              const Text('B’ELITEZ',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 5)),
              RichText(text: TextSpan(
                style: TextStyle(fontSize: titleSize, height: .9, fontWeight: FontWeight.w900),
                children: const [
                  TextSpan(text: 'B', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'ELITEZ', style: TextStyle(color: AppTheme.teal)),
                ],
              )),
              Text('2K26',
                style: TextStyle(color: const Color(0xFFDDE7F2), fontSize: titleSize * .72, fontWeight: FontWeight.w900, height: .9)),
              const SizedBox(height: 24),
              const Text(
                'A dynamic biomedical symposium for ideas, innovation, competition, creativity and collaboration.',
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xFFB5C8DD), fontSize: 17, height: 1.6),
              ),
              const SizedBox(height: 30),
              Wrap(
                alignment: stacked ? WrapAlignment.center : WrapAlignment.start,
                spacing: 12, runSpacing: 12,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.teal,
                      foregroundColor: AppTheme.dark,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                    ),
                    child: const Text('Register Now →', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/events'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF3B526C)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                    ),
                    child: const Text('Explore Events', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ],
          );

          final visual = Container(
            height: stacked ? 300 : 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0x2238D7D0)),
              gradient: const RadialGradient(
                center: Alignment.center,
                radius: .85,
                colors: [Color(0x2032D9D0), Color(0x00000000)],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: stacked ? 220 : 310, height: stacked ? 220 : 310,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.teal, width: 2)),
                ),
                Container(
                  width: stacked ? 145 : 195, height: stacked ? 145 : 195,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.navy2,
                    border: Border.all(color: AppTheme.blue, width: 3)),
                  //child: const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 75),
                  child:  Image.asset('assets/images/biomedical-crest.png', fit: BoxFit.contain),
                ),
                const Positioned(top: 32, left: 34, child: _Floating(label: 'BIO', icon: '🧬')),
                const Positioned(top: 72, right: 30, child: _Floating(label: 'AI', icon: '🧠')),
                const Positioned(bottom: 38, left: 45, child: _Floating(label: 'MED', icon: '⚕️')),
                const Positioned(bottom: 50, right: 35, child: _Floating(label: 'LAB', icon: '🔬')),
              ],
            ),
          );

          if (stacked) return Column(children: [visual, const SizedBox(height: 45), content]);
          return Row(children: [
            Expanded(child: content),
            const SizedBox(width: 55),
            Expanded(child: visual),
          ]);
        }),
      ),
    ),
  );

  Widget _notice() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    color: const Color(0xFFFFF8F0),
    child: const Center(
      child: Text.rich(TextSpan(children: [
        TextSpan(text: '📌 Important: ', style: TextStyle(fontWeight: FontWeight.w900)),
        TextSpan(text: 'Accommodation will not be provided.'),
      ])),
    ),
  );

  Widget _events(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('COMPETE • CREATE • CONNECT',
              style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 9),
            Row(children: [
              const Expanded(child: Text('Symposium Events', style: TextStyle(fontSize: 43, fontWeight: FontWeight.w900))),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/events'), child: const Text('View all →')),
            ]),
            const SizedBox(height: 28),
            LayoutBuilder(builder: (_, c) {
              final n = c.maxWidth > 950 ? 3 : c.maxWidth > 620 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: n,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: n == 1 ? 1.7 : 1.2,
                ),
                itemBuilder: (_, i) => EventCard(event: events[i]),
              );
            }),
          ],
        ),
      ),
    ),
  );

  Widget _cta(BuildContext context) => Container(
    width: double.infinity,
    color: AppTheme.navy,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1150),
        child: LayoutBuilder(builder: (_, c) {
          final stacked = c.maxWidth < 700;
          final copy = const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('READY?', style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
              SizedBox(height: 7),
              Text('Make your mark at B’ELITEZ 2K26.',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
              SizedBox(height: 7),
              Text('Choose your events and complete your registration in a few minutes.',
                style: TextStyle(color: Color(0xFF9EB2C9))),
            ],
          );
          if (stacked) {
            return Column(children: [
            copy,
            const SizedBox(height: 22),
            Align(alignment: Alignment.centerLeft, child: FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark),
              child: const Text('Start Registration →', style: TextStyle(fontWeight: FontWeight.w900)),
            )),
          ]);
          }
          return Row(children: [
            Expanded(child: copy),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark),
              child: const Text('Start Registration →', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ]);
        }),
      ),
    ),
  );
}

class _Floating extends StatelessWidget {
  final String label, icon;
  const _Floating({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xEE10233B),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0x334AD7D0)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 7),
      Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    ]),
  );
}
