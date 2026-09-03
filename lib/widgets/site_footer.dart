import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navy,
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: Column(
            children: [
              LayoutBuilder(builder: (_, c) {
                if (c.maxWidth < 700) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FooterCol(title: 'MAHENDRA COLLEGE OF ENGINEERING',
                        lines: ['Department of Biomedical Engineering', "B'ELITEZ 2K26", 'National Level Technical Symposium']),
                      SizedBox(height: 30),
                      _FooterCol(title: 'Quick Links',
                        lines: ['Department', "B'ELITEZ 2K26", 'Events', 'Registration']),
                      SizedBox(height: 30),
                      _FooterCol(title: 'Website Queries',
                        lines: ['Registration/payment/technical support', '9566398331 / 7448665022', 'belitez2k26@gmail.com']),
                    ],
                  );
                }
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _FooterCol(title: 'MAHENDRA COLLEGE OF ENGINEERING',
                      lines: ['Department of Biomedical Engineering', "B'ELITEZ 2K26", 'National Level Technical Symposium'])),
                    Expanded(child: _FooterCol(title: 'Quick Links',
                      lines: ['Department', "B'ELITEZ 2K26", 'Events', 'Registration'])),
                    Expanded(child: _FooterCol(title: 'Website Queries',
                      lines: ['Registration/payment/technical support', '9566398331 / 7448665022', 'belitez2k26@gmail.com'])),
                  ],
                );
              }),
              const SizedBox(height: 30),
              const Divider(color: Color(0xFF26364A)),
              const SizedBox(height: 14),
              const Text('© 2026 B’ELITEZ 2K26 • Mahendra College of Engineering',
                style: TextStyle(color: Color(0xFF6F829A))),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterCol extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _FooterCol({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.monitor_heart_outlined, color: AppTheme.teal, size: 38),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ...lines.map((x) => Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Text(x, style: const TextStyle(color: Color(0xFF9FB0C5), height: 1.35)),
        )),
      ],
    ),
  );
}
