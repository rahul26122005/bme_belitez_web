import 'package:flutter/material.dart';
import '../utils/theme.dart';

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  const SiteHeader({super.key, this.showBack = false});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.navy,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 76,
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 760;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Row(
                children: [
                  if (showBack)
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  _brand(context),
                  const Spacer(),
                  if (!compact) ...[
                    _nav(context, 'Department', '/'),
                    _nav(context, "B'ELITEZ 2K26", '/register-home'),
                    _nav(context, 'Events', '/events'),
                    const SizedBox(width: 8),
                    _register(context),
                  ] else
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
                      onSelected: (value) {
                        if (value == 'register') {
                          Navigator.pushNamed(context, '/register');
                        } else {
                          Navigator.pushNamed(context, value);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: '/', child: Text('Department')),
                        PopupMenuItem(value: '/register-home', child: Text("B'ELITEZ 2K26")),
                        PopupMenuItem(value: '/events', child: Text('Events')),
                        PopupMenuItem(value: 'register', child: Text('Register')),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _brand(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.cyan, width: 2),
              gradient: const LinearGradient(colors: [AppTheme.navy2, AppTheme.navy]),
            ),
            //child: const Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 27),
            child:  Image.asset('assets/images/mahalogo.png', fit: BoxFit.fill),
          ),
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MAHENDRA COLLEGE OF ENGINEERING',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5)),
              SizedBox(height: 3),
              Text('DEPARTMENT OF BIOMEDICAL ENGINEERING',
                style: TextStyle(color: Color(0xFF9AA9BC), fontSize: 7.5, letterSpacing: 1.1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nav(BuildContext context, String text, String route) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(text, style: const TextStyle(color: Color(0xFFD5DFEB), fontWeight: FontWeight.w700)),
    ),
  );

  Widget _register(BuildContext context) => FilledButton(
    onPressed: () => Navigator.pushNamed(context, '/register'),
    style: FilledButton.styleFrom(
      backgroundColor: AppTheme.teal,
      foregroundColor: AppTheme.dark,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w900)),
  );
}
