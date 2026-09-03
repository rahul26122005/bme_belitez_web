import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/site_footer.dart';
import '../widgets/site_header.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _hero(context),
            _focusSection(context),
            _journey(),
            _enterCta(context),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context) => Container(
    width: double.infinity,
    color: const Color(0xFFF7FAFD),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 82),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: LayoutBuilder(builder: (_, c) {
          final stacked = c.maxWidth < 850;
          final text = Column(
            crossAxisAlignment: stacked ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              const Text('DEPARTMENT WEBSITE',
                style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 15),
              Text('Department of\nBiomedical\nEngineering',
                textAlign: stacked ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: c.maxWidth < 500 ? 42 : 58,
                  height: .98,
                  fontWeight: FontWeight.w900,
                )),
              const SizedBox(height: 24),
              const Text(
                'Biomedical Engineering combines engineering principles with biological and medical sciences to develop technologies that improve diagnosis, monitoring, rehabilitation and patient care.',
                style: TextStyle(color: AppTheme.muted, fontSize: 17, height: 1.65),
              ),
              const SizedBox(height: 34),
              LayoutBuilder(builder: (_, inner) {
                final small = inner.maxWidth < 520;
                return small ? const Column(
                  children: [
                    _MiniFeature(number: '01', title: 'Medical Instrumentation'),
                    SizedBox(height: 18),
                    _MiniFeature(number: '02', title: 'Biomedical Signals'),
                    SizedBox(height: 18),
                    _MiniFeature(number: '03', title: 'Healthcare Innovation'),
                  ],
                ) : const Row(
                  children: [
                    Expanded(child: _MiniFeature(number: '01', title: 'Medical Instrumentation')),
                    SizedBox(width: 18),
                    Expanded(child: _MiniFeature(number: '02', title: 'Biomedical Signals')),
                    SizedBox(width: 18),
                    Expanded(child: _MiniFeature(number: '03', title: 'Healthcare Innovation')),
                  ],
                );
              }),
            ],
          );

          final visual = Container(
            height: stacked ? 310 : 440,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAF8F8), Color(0xFFDCE9FF)],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: stacked ? 190 : 270,
                  height: stacked ? 190 : 270,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.teal, width: 4),
                  ),
                ),
                Container(
                  width: stacked ? 125 : 175,
                  height: stacked ? 125 : 175,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.navy,
                    boxShadow: const [BoxShadow(blurRadius: 35, color: Color(0x3316C4B8))],
                  ),
                  // child: const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 70),
                  child:  Image.asset('assets/images/biomedical-crest.png', fit: BoxFit.contain),
                ),
                const Positioned(top: 34, left: 34, child: _OrbitCard(icon: '🔬', title: 'Research')),
                const Positioned(bottom: 32, left: 28, child: _OrbitCard(icon: '⚕️', title: 'Healthcare')),
                const Positioned(right: 28, top: 70, child: _OrbitCard(icon: '🧠', title: 'Technology')),
              ],
            ),
          );

          if (stacked) return Column(children: [visual, const SizedBox(height: 45), text]);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: visual),
              const SizedBox(width: 72),
              Expanded(flex: 6, child: text),
            ],
          );
        }),
      ),
    ),
  );

  Widget _focusSection(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ENGINEERING FOR LIFE',
              style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 10),
            const Text('What biomedical engineering connects',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: AppTheme.text)),
            const SizedBox(height: 28),
            LayoutBuilder(builder: (_, c) {
              final n = c.maxWidth > 900 ? 3 : c.maxWidth > 560 ? 2 : 1;
              return GridView.count(
                crossAxisCount: n,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.25,
                children: const [
                  _InfoCard(icon: Icons.biotech_outlined, title: 'Research', text: 'Evidence-driven innovation for better healthcare outcomes.'),
                  _InfoCard(icon: Icons.medical_services_outlined, title: 'Healthcare', text: 'Engineering solutions designed around patients and clinicians.'),
                  _InfoCard(icon: Icons.memory_outlined, title: 'Technology', text: 'Smart systems, instrumentation, imaging and rehabilitation.'),
                ],
              );
            }),
          ],
        ),
      ),
    ),
  );

  Widget _journey() => Container(
    width: double.infinity,
    color: AppTheme.navy,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: LayoutBuilder(builder: (_, c) {
          final n = c.maxWidth > 850 ? 4 : c.maxWidth > 560 ? 2 : 1;
          return GridView.count(
            crossAxisCount: n,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 0,
            mainAxisSpacing: 25,
            childAspectRatio: 2.4,
            children: const [
              _Journey(number: '01', title: 'LEARN', text: 'Build biomedical foundations'),
              _Journey(number: '02', title: 'CREATE', text: 'Turn ideas into solutions'),
              _Journey(number: '03', title: 'INNOVATE', text: 'Design future healthcare'),
              _Journey(number: '04', title: 'CONNECT', text: 'Meet innovators'),
            ],
          );
        }),
      ),
    ),
  );

  Widget _enterCta(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 76),
    color: AppTheme.lightBg,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(24),
          ),
          child: LayoutBuilder(builder: (_, c) {
            final stacked = c.maxWidth < 700;
            final content = Row(
              children: [
                Container(
                  width: 62, height: 62,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.navy),
                  // child: const Icon(Icons.monitor_heart_outlined, color: AppTheme.teal, size: 34),
                  child:  Image.asset('assets/images/biomedical-crest.png', fit: BoxFit.contain),
                ),
                const SizedBox(width: 18),
                const Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEXT • B’ELITEZ 2K26', style: TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900, letterSpacing: 1.7)),
                    SizedBox(height: 6),
                    Text('Ready to enter the symposium?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    SizedBox(height: 5),
                    Text('Continue to the official symposium registration home page.', style: TextStyle(color: AppTheme.muted)),
                  ],
                )),
                FilledButton(
                  onPressed: null,
                  child: Text('Go to Symposium →'),
                ),
              ],
            );
            if (stacked) return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content.children.first,
                const SizedBox(height: 18),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  content.children[2],
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/register-home'),
                    style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark),
                    child: const Text('Go to Symposium →', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ]),
              ],
            );
            return Row(
              children: [
                content.children[0],
                const SizedBox(width: 18),
                content.children[1],
                const SizedBox(width: 18),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(context, '/register-home'),
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.teal, foregroundColor: AppTheme.dark),
                  child: const Text('Go to Symposium →', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            );
          }),
        ),
      ),
    ),
  );
}

class _MiniFeature extends StatelessWidget {
  final String number, title;
  const _MiniFeature({required this.number, required this.title});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(height: 2, color: AppTheme.teal),
      const SizedBox(height: 9),
      Text(number, style: const TextStyle(color: AppTheme.teal, fontSize: 11, fontWeight: FontWeight.w900)),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    ],
  );
}

class _OrbitCard extends StatelessWidget {
  final String icon, title;
  const _OrbitCard({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.9),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [BoxShadow(color: Color(0x14132336), blurRadius: 20)],
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    ]),
  );
}

class _InfoCard extends StatelessWidget {
  final IconData icon; final String title, text;
  const _InfoCard({required this.icon, required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AppTheme.teal, size: 35),
      const SizedBox(height: 18),
      Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Text(text, style: const TextStyle(color: AppTheme.muted, height: 1.45)),
    ]),
  );
}

class _Journey extends StatelessWidget {
  final String number, title, text;
  const _Journey({required this.number, required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 22),
    decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFF30445C)))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(number, style: const TextStyle(color: AppTheme.teal, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 5),
      Text(text, style: const TextStyle(color: Color(0xFF91A7BE))),
    ]),
  );
}
